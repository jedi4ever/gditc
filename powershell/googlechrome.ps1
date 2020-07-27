#ProgressWriter -Status "Downloading Google Chrome" -PercentComplete $PercentComplete
(New-Object System.Net.WebClient).DownloadFile("https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi", "C:\downloads\googlechromestandaloneenterprise64.msi")
start-process -filepath "C:\Windows\System32\msiexec.exe" -ArgumentList '/qn /i "C:\downloads\googlechromestandaloneenterprise64.msi"' -Wait
