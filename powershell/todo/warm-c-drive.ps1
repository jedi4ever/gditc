# create shortcut to warm c drive (if on AWS)
if ($Using:IsAWS) {
    (New-Object System.Net.WebClient).DownloadFile("http://www.chrysocome.net/downloads/dd-0.6beta3.zip", "c:\cloudygamer\downloads\dd.zip")
    Expand-Archive -LiteralPath "c:\cloudygamer\downloads\dd.zip" -DestinationPath "c:\cloudygamer\dd"
    '& "c:\cloudygamer\dd\dd.exe" @("if=\\.\PHYSICALDRIVE$((Get-Partition -DriveLetter "C").DiskNumber)", "of=/dev/null", "bs=1M", "--progress", "--size")' > c:\cloudygamer\dd\read-drive.ps1
    $Shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut("$home\Desktop\Warm C Drive.lnk")
    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-File c:\cloudygamer\dd\read-drive.ps1"
    $Shortcut.Save()
    $bytes = [System.IO.File]::ReadAllBytes("$home\Desktop\Warm C Drive.lnk")
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [System.IO.File]::WriteAllBytes("$home\Desktop\Warm C Drive.lnk", $bytes)
  }