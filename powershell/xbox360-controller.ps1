# requires 7zip
# the devcon has nothing specific to do with vigem , it's just that this got download in that directory

#Checks for Server 2019 and asks user to install Windows Xbox Accessories in order to let their controller work
Function Server2019Controller {
    # ProgressWriter -Status "Adding Xbox 360 Controller driver to Windows Server 2019" -PercentComplete $PercentComplete
    if ((gwmi win32_operatingsystem | % caption) -like '*Windows Server 2019*') {
        (New-Object System.Net.WebClient).DownloadFile("http://download.microsoft.com/download/6/9/4/69446ACF-E625-4CCF-8F56-58B589934CD3/Xbox360_64Eng.exe", "C:\downloads\Xbox360_64Eng.exe")
        cmd.exe /c '"C:\Program Files\7-Zip\7z.exe" x C:\downloads\Xbox360_64Eng.exe -oC:\downloads\Xbox360_64Eng -y' 
        cmd.exe /c '"C:\Program Files (x86)\Windows Kits\10\Tools\x64\devcon.exe" dp_add "C:\downloads\Xbox360_64Eng\xbox360\setup64\files\driver\win7\xusb21.inf"'
        }
    }

Server2019Controller