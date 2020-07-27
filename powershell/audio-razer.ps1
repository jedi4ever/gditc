#Move extracts Razer Surround Files into correct location
Function ExtractRazerAudio {
    cmd.exe /c '"C:\Program Files\7-Zip\7z.exe" x C:\downloads\razer-surround-driver.exe -oC:\downloads\razer-surround-driver -y'
}

#modifys the installer manifest to run without interraction
Function ModifyManifest {
    $InstallerManifest = 'C:\downloads\razer-surround-driver\$TEMP\RazerSurroundInstaller\InstallerManifest.xml'
    $regex = '(?<=<SilentMode>)[^<]*'
    (Get-Content $InstallerManifest) -replace $regex, 'true' | Set-Content $InstallerManifest -Encoding UTF8
    }

 #Audio Driver Install
function AudioInstall {
    (New-Object System.Net.WebClient).DownloadFile("http://rzr.to/surround-pc-download", "C:\downloads\razer-surround-driver.exe")
    ExtractRazerAudio
    ModifyManifest
    $OriginalLocation = Get-Location
    Set-Location -Path 'C:\downloads\razer-surround-driver\$TEMP\RazerSurroundInstaller\'
    Start-Process RzUpdateManager.exe
    Set-Location $OriginalLocation
    Set-Service -Name audiosrv -StartupType Automatic

     #Shit who knows. Wait for the above update manager to do it's magic and then remove start up for next boot
     Write-Output "120s for Audio Drivers to finalize"
     Start-Sleep -s 120
    }

    # https://chocolatey.org/packages/razer-synapse-2#files
    #   silentArgs             = "/S /v/qn"

    function Remove-Razer-Startup {
        if (((Get-Item -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run).GetValue("Razer Synapse") -ne $null) -eq $true) 
        {Remove-ItemProperty -path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -Name "Razer Synapse"
        "Removed Startup Item from Razer Synapse"}
        Else {"Razer Startup Item not present"}
        }
    
Remove-Razer-Startup   
AudioInstall
      
