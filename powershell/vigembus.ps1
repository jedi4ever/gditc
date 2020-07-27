# Vigembus - https://github.com/ViGEm/ViGEmBus
# Windows kernel-mode driver emulating well-known USB game controllers.

Function InstallViGEmBus {
    #Required for Controller Support.
    #$Vigem = @{}
    #$Vigem.DriverFile = "C:\Program Files\Parsec\Vigem\ViGEmBus.cat";
    #$Vigem.CertName = 'C:\Program Files\Parsec\Vigem\Wohlfeil_IT_e_U_.cer';
    #$Vigem.ExportType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Cert;
    #$Vigem.Cert = (Get-AuthenticodeSignature -filepath $vigem.DriverFile).SignerCertificate; 
    #$Vigem.CertInstalled = if ((Get-ChildItem -Path Cert:\CurrentUser\TrustedPublisher | Where-Object Subject -Like "*CN=Wohlfeil.IT e.U., O=Wohlfeil.IT e.U.*" ) -ne $null) {$True}
    #Else {$false}
    #if ($vigem.CertInstalled -eq $true) {
    cmd.exe /c '"C:\Program Files (x86)\Windows Kits\10\Tools\x64\devcon.exe" install "C:\Program Files\Parsec\vigem\10\ViGEmBus.inf" Nefarius\ViGEmBus\Gen1' 
    #} 
    #Else {[System.IO.File]::WriteAllBytes($Vigem.CertName, $Vigem.Cert.Export($Vigem.ExportType));
    #Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher -FilePath 'C:\Program Files\Parsec\Vigem\Wohlfeil_IT_e_U_.cer' | Out-Null
    #Start-Sleep 5
    #cmd.exe /c '"C:\Program Files\Parsec\vigem\devcon.exe" install "C:\Program Files\Parsec\vigem\ViGEmBus.inf" Root\ViGEmBus' | Out-Null
    #}
    }
InstallViGEmBus