# Needs to have downloads dir created first
#ProgressWriter -Status "Downloading Google Chrome" -PercentComplete $PercentComplete
md c:\downloads

#https://downloads.ndi.tv/SDK/NDI_SDK_Unreal_Engine/NDI%20SDK%20for%20Unreal%20Engine.exe
# https://downloads.ndi.tv/SDK/NDI_SDK_Unreal_Engine/NDISDKforUnrealEngineDownloads.htm

(New-Object System.Net.WebClient).DownloadFile("https://downloads.ndi.tv/SDK/NDI_SDK_Unreal_Engine/NDI%20SDK%20for%20Unreal%20Engine.exe", "C:\downloads\unreal-ndi.exe")
(New-Object System.Net.WebClient).DownloadFile("https://downloads.ndi.tv/Tools/NDI%204%20Tools.exe", "C:\downloads\ndi-tools.exe")


# https://forums.newtek.com/showthread.php/161183-NDI-Tools-silent-installer-component-switches
# In particular, run the installer interactively with the "/SAVEINF=filename" option, and the options you select get written to a file for reusing with the /LOADINF=filename option.

Copy-Item "c:\scripts\newtek-unreal-silent.txt" -Destination "c:\downloads\"
Copy-Item "c:\scripts\newtek-tools-silent.txt" -Destination "c:\downloads\"

# This will not work as it is always ask for a license
#start-process -filepath "c:\downloads\ndi-tools.exe" -ArgumentList '/LOADINF="c:\downloads\newtek-tools-silent.txt"' -Wait
#start-process -filepath "c:\downloads\unreal-ndi.exe" -ArgumentList '/LOADINF="c:\downloads\newtek-unreal-silent.txt"' -Wait


# So we use it via the scheduler
# We would like it to install even if the user doesn't login, but the installer requires interaction

# It supposedly works by setting the taks in windows2003 compatibility mode , but it didn't work so far
# https://www.autoitscript.com/forum/topic/195184-autoit-script-to-navigate-ie-cannot-be-executed-in-task-scheduler-in-win10-vm/

# https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks-create#to-schedule-a-task-to-run-when-a-user-logs-on
# /z	Specifies to delete the task upon the completion of its schedule.

# Note this requires autoit3 to be installed
# "c:\Program Files (x86)\AutoIt3\AutoIt3.exe" c:\scripts\ndi-tools.au3

# We do it in a batch script, so we can disable ourselves after running
# At logon , with highest priviledge
schtasks /create /tn "ndi tools auto installer" /tr "c:\scripts\ndi-tools.bat" /sc onlogon /RL HIGHEST


# schtasks /Change /TN "ndi tools auto installer" /Enable
# schtasks /Change /TN "ndi tools auto installer" /Disable
