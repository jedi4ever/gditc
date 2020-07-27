#Provider specific driver install and setup
Function provider-specific {
    ProgressWriter -Status "Installing Audio Driver if required and removing system information from appearing on Google Cloud Desktops" -PercentComplete $PercentComplete
    #Device ID Query 
    $gputype = get-wmiobject -query "select DeviceID from Win32_PNPEntity Where (deviceid Like '%PCI\\VEN_10DE%') and (PNPClass = 'Display' or Name = '3D Video Controller')" | Select-Object DeviceID -ExpandProperty DeviceID
    if ($gputype -eq $null) {
        }
    Else {
            if($gputype.substring(13,8) -eq "DEV_13F2") {
            #AWS G3.4xLarge M60
            AudioInstall
            }
        ElseIF($gputype.Substring(13,8) -eq "DEV_118A"){
            #AWS G2.2xLarge K520
            AudioInstall
            }
        ElseIF($gputype.Substring(13,8) -eq "DEV_1BB1") {
            #Paperspace P4000
            } 
        Elseif($gputype.Substring(13,8) -eq "DEV_1BB0") {
            #Paperspace P5000
            }
        Elseif($gputype.substring(13,8) -eq "DEV_15F8") {
            #Tesla P100
            if((Test-Path "C:\Program Files\Google\Compute Engine\tools\BGInfo.exe") -eq $true) {remove-item -path "C:\Program Files\Google\Compute Engine\tools\BGInfo.exe"} Else {}
            if((Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\BGinfo.lnk") -eq $true) {Remove-Item -path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\BGinfo.lnk"} Else {}
            AudioInstall
            }
        Elseif($gputype.substring(13,8) -eq "DEV_1BB3") {
            #Tesla P4
            if((Test-Path "C:\Program Files\Google\Compute Engine\tools\BGInfo.exe") -eq $true) {remove-item -path "C:\Program Files\Google\Compute Engine\tools\BGInfo.exe"} Else {}
            if((Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\BGinfo.lnk") -eq $true) {Remove-Item -path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\BGinfo.lnk"} Else {}
            autologin
            AudioInstall
            }
        Elseif($gputype.substring(13,8) -eq "DEV_1EB8") {
            #Tesla T4
            if((Test-Path "C:\Program Files\Google\Compute Engine\tools\BGInfo.exe") -eq $true) {remove-item -path "C:\Program Files\Google\Compute Engine\tools\BGInfo.exe"} Else {}
            if((Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\BGinfo.lnk") -eq $true) {Remove-Item -path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\BGinfo.lnk"} Else {}
            AudioInstall
            }
        Elseif($gputype.substring(13,8) -eq "DEV_1430") {
            #Quadro M2000
            AudioInstall
            }
        Else {
            }
        }
    }