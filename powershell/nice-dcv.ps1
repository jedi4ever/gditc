# Needs to have downloads dir created first
#ProgressWriter -Status "Downloading Google Chrome" -PercentComplete $PercentComplete
md c:\downloads

(New-Object System.Net.WebClient).DownloadFile("https://d1uj6qtbmh3dt5.cloudfront.net/2020.2/Servers/nice-dcv-server-x64-Release-2020.2-9662.msi", "C:\downloads\nice-dcv-server-x64-Release-2020.2-9662.msi")

# https://download.nice-dcv.com/
# https://d1uj6qtbmh3dt5.cloudfront.net/2020.2/Servers/nice-dcv-server-x64-Release-2020.2-9662.msi

# https://docs.aws.amazon.com/dcv/latest/adminguide/setting-up-installing-wininstall.html#setting-up-installing-windows-unattended
start-process -filepath "C:\Windows\System32\msiexec.exe" -ArgumentList '/i "C:\downloads\nice-dcv-server-x64-Release-2020.2-9662.msi" ADDLOCAL=ALL /quiet /norestart /l*v dcv_install_msi.log' -Wait
