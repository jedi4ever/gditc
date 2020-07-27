#creating a separate user to autologin and persist with ami
function new-autostart {
    $user = 'Gamer'
    $pass = 'CoolP455'
    # Create the local user
    net user $user $pass /ADD /expires:never

    # Set the above local user to not have an expiring password
    Get-WmiObject Win32_UserAccount -filter "LocalAccount=True"| Where-Object {$_.name -eq $user} | Set-WmiInstance -Arguments @{PasswordExpires=$false}

    # Create registry keys for local login
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -PropertyType "String" -Value $user
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -PropertyType "String" -Value $pass
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultDomainName" -PropertyType "String" -Value '.\'
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -PropertyType "String" -Value '1'

    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoLogonSID"
}
