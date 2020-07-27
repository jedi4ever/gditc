function install_nvidia_2 {

    # https://github.com/badjware/aws-cloud-gaming/blob/master/templates/user_data.tpl#L56


    # https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/install-nvidia-driver.html#nvidia-gaming-driver
    if (!(Test-Path -Path "C:\Program Files\NVIDIA Corporation\NVSMI")) {
        $ExtractionPath = "C:\nvidia-driver\driver"
        $Bucket = ""
        $KeyPrefix = ""
        $InstallerFilter = "*win10*"
        %{ if regex("^g[0-9]+", var.instance_type) == "g3" }

        # GRID driver for g3
        $Bucket = "ec2-windows-nvidia-drivers"
        $KeyPrefix = "latest"

        # download driver
        $Objects = Get-S3Object -BucketName $Bucket -KeyPrefix $KeyPrefix -Region us-east-1
        foreach ($Object in $Objects) {
            $LocalFileName = $Object.Key
            if ($LocalFileName -ne '' -and $Object.Size -ne 0) {
                $LocalFilePath = Join-Path $ExtractionPath $LocalFileName
                Copy-S3Object -BucketName $Bucket -Key $Object.Key -LocalFile $LocalFilePath -Region us-east-1
            }
        }

        # disable licencing page in control panel
        New-ItemProperty -Path "HKLM:\SOFTWARE\NVIDIA Corporation\Global\GridLicensing" -Name "NvCplDisableManageLicensePage" -PropertyType "DWord" -Value "1"

        %{ else }
        %{ if regex("^g[0-9]+", var.instance_type) == "g4" }

        # vGaming driver for g4
        $Bucket = "nvidia-gaming"
        $KeyPrefix = "windows/latest"

        # download and extract driver
        $Objects = Get-S3Object -BucketName $Bucket -KeyPrefix $KeyPrefix -Region us-east-1
        foreach ($Object in $Objects) {
            if ($Object.Size -ne 0) {
                $LocalFileName = "C:\nvidia-driver\driver.zip"
                Copy-S3Object -BucketName $Bucket -Key $Object.Key -LocalFile $LocalFileName -Region us-east-1
                Expand-Archive $LocalFileName -DestinationPath $ExtractionPath
                break
            }
        }

        # install licence
        Copy-S3Object -BucketName $Bucket -Key "GridSwCert-Archive/GridSwCert-Windows_2020_04.cert" -LocalFile "C:\Users\Public\Documents\GridSwCert.txt" -Region us-east-1
        [microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global", "vGamingMarketplace", 0x02)

        %{ endif }
        %{ endif }

        if (Test-Path -Path $ExtractionPath) {
            # install driver
            $InstallerFile = Get-ChildItem -path $ExtractionPath -Include $InstallerFilter -Recurse | ForEach-Object { $_.FullName }
            Start-Process -FilePath $InstallerFile -ArgumentList "/s /n" -Wait

            # install task to disable second monitor on login
            $trigger = New-ScheduledTaskTrigger -AtLogon
            $action = New-ScheduledTaskAction -Execute displayswitch.exe -Argument "/internal"
            Register-ScheduledTask -TaskName "disable-second-monitor" -Trigger $trigger -Action $action -RunLevel Highest

            # cleanup
            Remove-Item -Path "C:\nvidia-driver" -Recurse
        }
        else {
            $action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -Command `"(New-Object -ComObject Wscript.Shell).Popup('Automatic GPU driver installation is unsupported for this instance type: ${var.instance_type}. Please install them manually.')`""
            run-once-on-login "gpu-driver-warning" $action
        }
    }

}