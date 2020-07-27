
function download-parsec {
(New-Object System.Net.WebClient).DownloadFile("https://builds.parsecgaming.com/package/parsec-windows.exe", "C:\downloads\parsec-windows.exe")
}


#Move Parsec Files into correct location
Function ExtractInstallFiles {
    cmd.exe /c '"C:\Program Files\7-Zip\7z.exe" x C:\downloads\parsec-windows.exe -oC:\downloads\Parsec-Windows -y'
    if((Test-Path -Path 'C:\Program Files\Parsec')-eq $true) {} Else {New-Item -Path 'C:\Program Files\Parsec' -ItemType Directory }
    if((Test-Path -Path "C:\Program Files\Parsec\skel") -eq $true) {} Else {Move-Item -Path C:\downloads\Parsec-Windows\skel -Destination 'C:\Program Files\Parsec' } 
    if((Test-Path -Path "C:\Program Files\Parsec\vigem") -eq $true) {} Else  {Move-Item -Path C:\downloads\Parsec-Windows\vigem -Destination 'C:\Program Files\Parsec' } 
    if((Test-Path -Path "C:\Program Files\Parsec\wscripts") -eq $true) {} Else  {Move-Item -Path C:\downloads\Parsec-Windows\wscripts -Destination 'C:\Program Files\Parsec' } 
    if((Test-Path -Path "C:\Program Files\Parsec\parsecd.exe") -eq $true) {} Else {Move-Item -Path C:\downloads\Parsec-Windows\parsecd.exe -Destination 'C:\Program Files\Parsec'} 
    if((Test-Path -Path "C:\Program Files\Parsec\pservice.exe") -eq $true) {} Else {Move-Item -Path C:\downloads\Parsec-Windows\pservice.exe -Destination 'C:\Program Files\Parsec'} 
    Start-Sleep 1

}

# Start Parsec at login
# https://docs.microsoft.com/en-us/windows/win32/setupapi/run-and-runonce-registry-keys
function Install-Gaming-Apps {

    # ?? Not sure but it fails
New-ItemProperty -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name "Parsec.App.0" -Value "C:\Program Files\Parsec\parsecd.exe" 
Start-Process -FilePath "C:\Program Files\Parsec\parsecd.exe"
Start-Sleep -s 1

}


#Creates Parsec Firewall Rule in Windows Firewall
Function CreateFireWallRule {
    New-NetFirewallRule -DisplayName "Parsec" -Direction Inbound -Program "C:\Program Files\Parsec\Parsecd.exe" -Profile Private,Public -Action Allow -Enabled True 
    }

#Creates Parsec Service
Function CreateParsecService {
    cmd.exe /c 'sc.exe Create "Parsec" binPath= "\"C:\Program Files\Parsec\pservice.exe\"" start= "auto"' 
    sc.exe Start 'Parsec'
    }

    # C:\Users\%username%\AppData\Roaming\Parsec\config.txt

    # https://support.parsecgaming.com/hc/en-us/articles/360001562772-Advanced-Configuration
function parsec-save-settings {
        #SERGEY SETTINGS - AKA 50mbps :)
        <# 
        app_host=1
        app_run_level = 3
        encoder_h265 = 1
        encoder_min_bitrate = 50
        encoder_bitrate = 50
        server_resolution_x=2560
        server_resolution_y=1440
        server_refresh_rate=60
        #>
    
        $parsecOptions = @"
app_host=1
app_run_level = 3
encoder_h265 = 1
encoder_min_bitrate = 50
encoder_bitrate = 50
"@
        Write-Output $parsecOptions | Out-File -FilePath "C:\Users\Administrator\AppData\Roaming\Parsec\config.txt" -Encoding ascii
    }
    

download-parsec
ExtractInstallFiles
Install-Gaming-Apps
CreateFireWallRule
CreateParsecService
#parsec-save-settings
