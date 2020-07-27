#7Zip is required to extract the Parsec-Windows.exe File
function Install7Zip_2 {
    $url = Invoke-WebRequest -Uri https://www.7-zip.org/download.html -UseBasicParsing
    (New-Object System.Net.WebClient).DownloadFile("https://www.7-zip.org/$($($($url.Links | Where-Object outertext -Like "Download")[1]).OuterHTML.split('"')[1])" ,"C:\Downloads\7zip.exe")
    Start-Process C:\Dowloads\7zip.exe -ArgumentList '/S /D="C:\Program Files\7-Zip"' -Wait
}

# https://github.com/russiansmack/galaxy/blob/19032d9ede1ade0ca1850fb086345974d8aec714/golden.ps1#L158
function install-7zip_3 {
    #7Zip is required to extract the installers
    Write-Host "Downloading and Installing 7Zip"
    (New-Object System.Net.WebClient).DownloadFile("https://www.7-zip.org/a/7z1900-x64.exe" ,"$path\Apps\7zip.exe") | Unblock-File
    Start-Process $path\Apps\7zip.exe -ArgumentList '/S /D="C:\Program Files\7-Zip"' -Wait
}


function Install7Zip {
    choco install 7zip
}

Install7Zip