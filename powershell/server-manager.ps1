#Disables Server Manager opening on Startup
function disable-server-manager {
   # ProgressWriter -Status "Disabling Windows Server Manager from starting at startup" -PercentComplete $PercentComplete
    Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask | Out-Null
}


disable-server-manager