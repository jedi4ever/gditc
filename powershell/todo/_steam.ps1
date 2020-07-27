 # download steam
 (New-Object System.Net.WebClient).DownloadFile("https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe", "c:\downloads\steamsetup.exe")
 & c:\downloads\steamsetup.exe /S | Out-Null

 # create the task to restart steam (such that we're not stuck in services Session 0 desktop when launching)
 $action = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument @'
-Command "Stop-Process -Name "Steam" -Force -ErrorAction SilentlyContinue ; & 'C:\Program Files (x86)\Steam\Steam.exe'"
'@
 Register-ScheduledTask -Action $action -Description "called by SSM to restart steam. necessary to avoid being stuck in Session 0 desktop." -Force -TaskName "CloudyGamer Restart Steam" -TaskPath "\"
