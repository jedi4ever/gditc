function install-ssm {
    Write-Host "Installing AWS SSM"
    (New-Object System.Net.WebClient).DownloadFile("https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe", "$path\SSMAgent_latest.exe") | Unblock-File
    Start-Process -FilePath "$path\SSMAgent_latest.exe" -ArgumentList "/S"
}

install-ssm