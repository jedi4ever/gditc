$path = "C:\downloads" #Path for installer

function check-nvidia {
    $nvidiasmiarg = "-i 0 --query-gpu=driver_model.current --format=csv,noheader"
    $nvidiasmidir = "c:\program files\nvidia corporation\nvsmi\nvidia-smi" 
    $nvidiasmiresult = Invoke-Expression "& `"$nvidiasmidir`" $nvidiasmiarg"
    $nvidiadriverstatus = if($nvidiasmiresult -eq "WDDM") 
    {
        "GPU Driver status is good"
    }
    ElseIf($nvidiasmiresult -eq "TCC")
    {
        Write-Output "The GPU has incorrect mode TCC set - setting WDDM"
        $nvidiasmiwddm = "-g 0 -dm 0"
        $nvidiasmidir = "c:\program files\nvidia corporation\nvsmi\nvidia-smi" 
        Invoke-Expression "& `"$nvidiasmidir`" $nvidiasmiwddm"
    } Else{}
    $nvidiadriverstatus
}


function install_nvidia_parsec {
# https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/install-nvidia-driver.html#nvidia-gaming-driver
    if (!(Test-Path -Path "C:\Program Files\NVIDIA Corporation\NVSMI")) {
        # download from s3 and extract
        $Bucket = "nvidia-gaming"
        $KeyPrefix = "windows/latest"
        $Objects = Get-S3Object -BucketName $Bucket -KeyPrefix $KeyPrefix -Region us-east-1
        $LocalDownloadFile = "C:\nvidia-driver\driver.zip"
        $ExtractionPath = "C:\nvidia-driver\driver"
        foreach ($Object in $Objects) {
            if ($Object.Size -ne 0) {
                Copy-S3Object -BucketName $Bucket -Key $Object.Key -LocalFile $LocalDownloadFile -Region us-east-1
                Expand-Archive $LocalDownloadFile -DestinationPath $ExtractionPath
                break
            }
        }
    
        # install driver
        $InstallerFile = Get-ChildItem -path $ExtractionPath -Include "*win10*" -Recurse | ForEach-Object { $_.FullName }
        Start-Process -FilePath $InstallerFile -ArgumentList "/s /n" -Wait
     
        # install licence
        Copy-S3Object -BucketName $Bucket -Key "GridSwCert-Windows.cert" -LocalFile "C:\Users\Public\Documents\GridSwCert.txt" -Region us-east-1
        [microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global", "vGamingMarketplace", 0x02)
    

        # install task to disable second monitor on login
        $trigger = New-ScheduledTaskTrigger -AtLogon
        $action = New-ScheduledTaskAction -Execute displayswitch.exe -Argument "/internal"
        Register-ScheduledTask -TaskName "disable-second-monitor" -Trigger $trigger -Action $action -RunLevel Highest

        # cleanup
       Remove-Item -Path "C:\nvidia-driver" -Recurse
    }

}



# Reference: https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/install-nvidia-driver.html#nvidia-gaming-driver
# Notes: Required s3.getobject, s3.list-objects api calls
function download-nvidia {
    $Bucket = "nvidia-gaming"
    $KeyPrefix = "windows/latest"
    $LocalPath = "$path\NVIDIA"

    #Download drivers & Extract archives
    $Objects = Get-S3Object -BucketName $Bucket -KeyPrefix $KeyPrefix -Region us-east-1
    foreach ($Object in $Objects) {
        $LocalFileName = $Object.Key
        if ($LocalFileName -ne '' -and $Object.Size -ne 0) {
            $LocalFilePath = Join-Path $LocalPath $LocalFileName
            Copy-S3Object -BucketName $Bucket -Key $Object.Key -LocalFile $LocalFilePath -Region us-east-1

            $LocalFileDir = Join-Path $LocalPath $KeyPrefix
            Expand-Archive -Path $LocalFilePath -DestinationPath $LocalFileDir
        }
    }
}


function download-nvidia-grid {
    $Bucket = "ec2-windows-nvidia-drivers"
    $KeyPrefix = "g4/latest"
    $LocalPath = "$path\NVIDIA"

    #Download drivers & Extract archives
    $Objects = Get-S3Object -BucketName $Bucket -KeyPrefix $KeyPrefix -Region us-east-1
    foreach ($Object in $Objects) {
        $LocalFileName = $Object.Key
        if ($LocalFileName -ne '' -and $Object.Size -ne 0) {
            $LocalFilePath = Join-Path $LocalPath $LocalFileName
            Copy-S3Object -BucketName $Bucket -Key $Object.Key -LocalFile $LocalFilePath -Region us-east-1

            $LocalFileDir = Join-Path $LocalPath $KeyPrefix
            Expand-Archive -Path $LocalFilePath -DestinationPath $LocalFileDir
        }
    }
}

function install-nvidia {
    $KeyPrefix = "windows/latest"
    $LocalPath = "$path\NVIDIA"

    # Install Drivers
    $ArchiveFileDir = Join-Path $LocalPath $KeyPrefix
    $Installer = Get-ChildItem -Path $ArchiveFileDir\* -Include *win10*.exe

    Write-Host "Installing NVIDIA Drivers" -NoNewline
    Start-Process -FilePath $Installer -ArgumentList '/s' -wait

    # TODO bug with existing key error
    New-ItemProperty -Path "HKLM:\SOFTWARE\NVIDIA Corporation\Global" -Name "vGamingMarketplace" -Value "2" -PropertyType DWord

    # Download & Install Certification File
    $CertFileURL = "https://s3.amazonaws.com/nvidia-gaming/GridSwCert-Windows.cert"
    $CertFilePath = "$path\GridSwCert.txt"
    $CertFileInstallPath = "C:\Users\Public\Documents"

    Write-Host "Downloading CertFile" -NoNewline
    (New-Object System.Net.WebClient).DownloadFile($CertFileURL, $CertFilePath) | Unblock-File

    Copy-Item -Path $CertFilePath -Destination $CertFileInstallPath

    # Activate & Validate NVIDIA Gaming License
    $NvidiaAppPath = "C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe"
    $NvsmiLogFilePath = "$path\nvsmi.log"

    # TODO upload this file to something to validate and test build
    & $NvidiaAppPath -q | Out-File -FilePath $NvsmiLogFilePath

    # TODO bug with existing key error
    #New-ItemProperty -Path "HKLM:\SOFTWARE\NVIDIA Corporation\Global\GridLicensing" -Name "FeatureType" -Value "0" -PropertyType DWord
    #New-ItemProperty -Path "HKLM:\SOFTWARE\NVIDIA Corporation\Global\GridLicensing" -Name "IgnoreSP" -Value "1" -PropertyType DWord

    # Optimizing GPU
    Write-Host "Optimizing GPU"

    # Disable autoboost
    & $NvidiaAppPath --auto-boost-default=0 | Out-File -FilePath $NvsmiLogFilePath -Append

    # Set GPU to max freq on G4 instances
    # TODO optimize for each GPU
    & $NvidiaAppPath -ac "5001,1590" | Out-File -FilePath $NvsmiLogFilePath -Append
}


#GPU Detector
Function gpu-detector {
    #Device ID Query 
    $gputype = get-wmiobject -query "select DeviceID from Win32_PNPEntity Where (deviceid Like '%PCI\\VEN_10DE%') and (PNPClass = 'Display' or Name = '3D Video Controller')" | Select-Object DeviceID -ExpandProperty DeviceID
    if ($gputype -eq $null) 
    {
        Write-Output "No GPU Detected, skipping provider specific tasks"
    }
    Else
    {
        if($gputype.substring(13,8) -eq "DEV_13F2") 
        {
            #AWS G3.4xLarge M60
            Write-Output "Tesla M60 Detected"
        }
        ElseIF($gputype.Substring(13,8) -eq "DEV_118A")
        {
            #AWS G2.2xLarge K520
            Write-Output "GRID K520 Detected"
        }
        ElseIF($gputype.Substring(13,8) -eq "DEV_1BB1") 
        {
            #Paperspace P4000
            Write-Output "Quadro P4000 Detected"
        } 
        Elseif($gputype.Substring(13,8) -eq "DEV_1BB0") 
        {
            #Paperspace P5000
            Write-Output "Quadro P5000 Detected"
        }
        Elseif($gputype.substring(13,8) -eq "DEV_15F8") 
        {
            #Tesla P100
            Write-Output "Tesla P100 Detected"
        }
        Elseif($gputype.substring(13,8) -eq "DEV_1BB3") 
        {
            #Tesla P4
            Write-Output "Tesla P4 Detected"
        }
        Elseif($gputype.substring(13,8) -eq "DEV_1EB8") 
        {
            #Tesla T4
            Write-Output "Tesla T4 Detected"
        }
        Elseif($gputype.substring(13,8) -eq "DEV_1430") 
        {
            #Quadro M2000
            Write-Output "Quadro M2000 Detected"
        }
        Else
        {
            write-host "The installed GPU is not currently supported, skipping provider specific tasks"
        }
    }
}

install_nvidia_parsec
check-nvidia
gpu-detector


# download-nvidia
# download-nvidia-grid
# install-nvidia