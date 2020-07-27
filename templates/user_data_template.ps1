<powershell>

# Note - this is how we could verify winrm is working
# c:\> winrm identify -r:http://NODE:5985 -auth:basic -u:USERNAME -p:PASSWORD -encoding:utf-8
# http://www.dhruvsahni.com/verifying-winrm-connectivity

function install-winrm {

    Start-Transcript -path C:\userdata-winrm.log

    # https://github.com/jmassardo/Azure-WinRM-Terraform/blob/master/files/winrm.ps1

    Write-Host "Delete any existing WinRM listeners"
    winrm delete winrm/config/listener?Address=*+Transport=HTTP  2>$Null
    winrm delete winrm/config/listener?Address=*+Transport=HTTPS 2>$Null

    Write-Host "Create a new WinRM listener and configure"
    winrm create winrm/config/listener?Address=*+Transport=HTTP
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="0"}'
    winrm set winrm/config '@{MaxTimeoutms="7200000"}'
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    winrm set winrm/config/service '@{MaxConcurrentOperationsPerUser="12000"}'
    winrm set winrm/config/service/auth '@{Basic="true"}'
    winrm set winrm/config/client/auth '@{Basic="true"}'

    Write-Host "Configure UAC to allow privilege elevation in remote shells"
    $Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    $Setting = 'LocalAccountTokenFilterPolicy'
    Set-ItemProperty -Path $Key -Name $Setting -Value 1 -Force

    Write-Host "turn off PowerShell execution policy restrictions"
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

    Write-Host "Configure and restart the WinRM Service; Enable the required firewall exception"
    Stop-Service -Name WinRM
    Set-Service -Name WinRM -StartupType Automatic
    netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=allow localip=any remoteip=any
    Start-Service -Name WinRM

    Stop-Transcript

}


# Install SSHd to allow interaction debugging and execution
# Winrm works with terraform but is slow and has not easy interaction part

function install-sshd {

    Start-Transcript -path C:\userdata-sshd.log

    # There seems to be an issue with starting Openssh on windows server
    # We need to disable the Windows Updates first before it want to work
    # https://github.com/MicrosoftDocs/windowsserverdocs/issues/2074
    select -ExpandProperty UseWUServer 
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -Value 0 
    Restart-Service wuauserv

    # Requires admin privileges
    # From remote this fails with permission denied
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Start-Service sshd

    Stop-Transcript

}

install-winrm
install-sshd

</powershell>