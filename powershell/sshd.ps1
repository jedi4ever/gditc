#Requires -RunAsAdministrator

function install-sshd {

Start-Transcript -path C:\sshd.log

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
 {    
  Echo "This script needs to be run As Admin"
  Break
 }


# https://github.com/MicrosoftDocs/windowsserverdocs/issues/2074


# $currentWU = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" 
# select -ExpandProperty UseWUServer 

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -Value 0 
Restart-Service wuauserv
## Get-WindowsCapability -Name RSAT* -Online 
## Add-WindowsCapability –Online Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -Value $currentWU 
## Restart-Service wuauserv

# Requires admin privileges
# From remote this fails with permission denied
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

## Change server start-up to Automatic 
Set-Service -Name sshd -StartupType 'Automatic'

## Start the Server and change start-up to Automatic
Start-Service sshd

Stop-Transcript

}

# https://www.concurrency.com/blog/may-2019/key-based-authentication-for-openssh-on-windows
function install-ssh-keys {

    Start-Transcript -path C:\ssh-keys.log

    $acl = Get-Acl C:\ProgramData\ssh\administrators_authorized_keys
    $acl.SetAccessRuleProtection($true, $false)
    $administratorsRule = New-Object system.security.accesscontrol.filesystemaccessrule("Administrators","FullControl","Allow")
    $systemRule = New-Object system.security.accesscontrol.filesystemaccessrule("SYSTEM","FullControl","Allow")
    $acl.SetAccessRule($administratorsRule)
    $acl.SetAccessRule($systemRule)
    $acl | Set-Acl

    Stop-Transcript

}

# Run it again just in case , this is already run in the userdata
install-sshd

install-ssh-keys