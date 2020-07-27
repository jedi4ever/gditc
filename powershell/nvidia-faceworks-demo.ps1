function nvidia-faceworks {
    Write-Host "Downloading NVIDIA TAKE MY MONEY DEMO"
    (New-Object System.Net.WebClient).DownloadFile("https://us.download.nvidia.com/downloads/cool_stuff/demos/SetupFaceWorks.exe", "c:\downloads\SetupFaceWorks.exe") | Unblock-File
    Start-Process -FilePath "c:\downloads\SetupFaceWorks.exe" -ArgumentList "/S"
    #   Start-Process -FilePath "c:\downloads\SetupFaceWorks.exe" -ArgumentList "/S" -wait
}

nvidia-faceworks