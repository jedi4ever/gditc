# https://docs.microsoft.com/en-gb/windows-hardware/drivers/devtest/devcon?redirectedfrom=MSDN
# DevCon (Devcon.exe), the Device Console, is a command-line tool that displays detailed information about devices on computers running Windows. 
# You can use DevCon to enable, disable, install, configure, and remove devices.
# DevCon runs on Microsoft Windows 2000 and later versions of Windows.
# DevCon (Devcon.exe) is included when you install the WDK, Visual Studio, and the

# looking further
# https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk
# visual studio installation (community)
# https://download.visualstudio.microsoft.com/download/pr/067fd8d0-753e-4161-8780-dfa3e577839e/771a4c18e31ccc341097af13302792331817ae81fce20f8c99799163d87733d4/vs_Community.exe

# https://superuser.com/questions/1002950/quick-method-to-install-devcon-exe
# https://superuser.com/questions/1002950/quick-method-to-install-devcon-exe/1099688#1099688

# Flags to auto install it
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2019
# %WindowsSdkDir%\tools\x64\devcon.exe

#     (New-Object System.Net.WebClient).DownloadFile("https://s3.amazonaws.com/parsec-files-ami-setup/Devcon/devcon.exe", "C:\ParsecTemp\Devcon\devcon.exe")

#choco install wget
#cd c:\downloads
#wget https://download.visualstudio.microsoft.com/download/pr/067fd8d0-753e-4161-8780-dfa3e577839e/771a4c18e31ccc341097af13302792331817ae81fce20f8c99799163d87733d4/vs_Community.exe
#cmd.exe /S /C ./vs_Community.exe --quiet --wait --norestart  --installPath C:\VisualStudio

#  “Install the EWDK 1703.” While it is a large download, once you have this downloaded and extracted
# https://quirkyvirtualization.net/2017/09/16/download-devcon/
# https://docs.microsoft.com/en-us/windows-hardware/drivers/develop/installing-the-wdk-build-environment-in-a-lab
# https://docs.microsoft.com/en-us/legal/windows/hardware/enterprise-wdk-license-2019

# wow 12Gb !
#curl https://go.microsoft.com/fwlink/p/?linkid=2128902 -o bla.exe


# https://chocolatey.org/packages/windowsdriverkit10/10.0.10586

choco install windowsdriverkit10

# C:\Program Files (x86)\Windows Kits\10\Tools\x64\devcon.exe
