Write-Status "Installing sound card"

# auto start audio service
Set-Service Audiosrv -startuptype "automatic"
Start-Service Audiosrv

# download and install driver
(New-Object System.Net.WebClient).DownloadFile("http://vbaudio.jcedeveloppement.com/Download_CABLE/VBCABLE_Driver_Pack43.zip", "c:\downloads\vbcable.zip")
Expand-Archive -LiteralPath "c:\downloads\vbcable.zip" -DestinationPath "c:\downloads\vbcable"
(Get-AuthenticodeSignature -FilePath "c:\downloads\vbcable\vbaudio_cable64_win7.cat").SignerCertificate | Export-Certificate -Type CERT -FilePath "c:\downloads\vbcable\vbcable.cer"
Import-Certificate -FilePath "c:\downloads\vbcable\vbcable.cer" -CertStoreLocation 'Cert:\LocalMachine\TrustedPublisher'
& c:\downloads\vbcable\VBCABLE_Setup_x64.exe -i
Sleep 10
Stop-Process -Name "VBCable_Setup_x64"
Import-Module DeviceManagement
if ($(Get-Device | where Name -eq "VB-Audio Virtual Cable").count -eq 0) {
  throw "VBCable failed to install"
}