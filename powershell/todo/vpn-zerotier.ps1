InlineScript {
    Write-Status "Installing VPN"

    # disable ipv6
    Set-Net6to4Configuration -State disabled
    Set-NetTeredoConfiguration -Type disabled
    Set-NetIsatapConfiguration -State disabled

    # install zerotier
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    (New-Object System.Net.WebClient).DownloadFile("https://download.zerotier.com/dist/ZeroTier%20One.msi", "c:\cloudygamer\downloads\zerotier.msi")
    & c:\cloudygamer\7za\7za x c:\cloudygamer\downloads\zerotier.msi -oc:\cloudygamer\downloads\zerotier
    (Get-AuthenticodeSignature -FilePath "c:\cloudygamer\downloads\zerotier\zttap300.cat").SignerCertificate | Export-Certificate -Type CERT -FilePath "c:\cloudygamer\downloads\zerotier\zerotier.cer"
    Import-Certificate -FilePath "c:\cloudygamer\downloads\zerotier\zerotier.cer" -CertStoreLocation 'Cert:\LocalMachine\TrustedPublisher'
    & msiexec /qn /i c:\cloudygamer\downloads\zerotier.msi | Out-Null
  }