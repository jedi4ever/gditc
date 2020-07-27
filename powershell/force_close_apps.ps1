#Sets all applications to force close on shutdown
function force-close-apps {
  #  ProgressWriter -Status "Setting Windows not to stop shutdown if there are unsaved apps" -PercentComplete $PercentComplete
    if (((Get-Item -Path "HKCU:\Control Panel\Desktop").GetValue("AutoEndTasks") -ne $null) -eq $true) {
        Set-ItemProperty -path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Value "1"
        }
    Else {
        New-ItemProperty -path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Value "1"
        }


#show hidden items
function show-hidden-items {
    ProgressWriter -Status "Showing hidden files in Windows Explorer" -PercentComplete $PercentComplete
    set-itemproperty -path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1 | Out-Null
    }

#show file extensions
function show-file-extensions {
    ProgressWriter -Status "Showing file extensions in Windows Explorer" -PercentComplete $PercentComplete
    Set-itemproperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name HideFileExt -Value 0 | Out-Null
    }


force-close-apps
show-hidden-items
show-file-extensions

