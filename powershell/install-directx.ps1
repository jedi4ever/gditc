#ProgressWriter -Status "Downloading DirectX June 2010 Redist" -PercentComplete $PercentComplete
(New-Object System.Net.WebClient).DownloadFile("https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe", "C:\downloads\directx_Jun2010_redist.exe") 
 
#ProgressWriter -Status "Installing DirectX June 2010 Redist" -PercentComplete $PercentComplete
Start-Process -FilePath "C:\downloads\directx_jun2010_redist.exe" -ArgumentList '/T:C:\downloads\DirectX /Q'-wait
Start-Process -FilePath "C:\downloads\DirectX\DXSETUP.EXE" -ArgumentList '/silent' -wait
