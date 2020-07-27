#set automatic time and timezone
function set-time {
   # ProgressWriter -Status "Setting computer time to automatic" -PercentComplete $PercentComplete
    Set-ItemProperty -path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters -Name Type -Value NTP | Out-Null
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate -Name Start -Value 00000003 | Out-Null
}

set-time