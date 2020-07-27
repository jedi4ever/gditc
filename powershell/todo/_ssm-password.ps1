# Change password (get it from SSM)
$password = (Get-SSMParameter -WithDecryption $true -Name '${password_ssm_parameter}').Value
net user Administrator "$password"