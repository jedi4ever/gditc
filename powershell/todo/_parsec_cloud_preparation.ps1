 # https://github.com/jamesstringerparsec/Parsec-Cloud-Preparation-Tool
    if (!(Test-Path -Path "C:\Parsec-Cloud-Preparation-Tool")) {
        [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
        (New-Object System.Net.WebClient).DownloadFile("https://github.com/badjware/Parsec-Cloud-Preparation-Tool/archive/master.zip","C:\Parsec-Cloud-Preparation-Tool.zip")
        New-Item -Path "C:\Parsec-Cloud-Preparation-Tool" -ItemType Directory
        Expand-Archive "C:\Parsec-Cloud-Preparation-Tool.zip" -DestinationPath "C:\Parsec-Cloud-Preparation-Tool"
        Remove-Item -Path "C:\Parsec-Cloud-Preparation-Tool.zip"
    
        # Setup scheduled task to run Parsec-Cloud-Preparation-Tool once at logon
        $taskname = "Parsec-Cloud-Preparation-Tool"
        $trigger = New-ScheduledTaskTrigger -AtLogon -RandomDelay $(New-TimeSpan -seconds 30)
        $trigger.Delay = "PT30S"
        $action = New-ScheduledTaskAction -Execute powershell.exe -WorkingDirectory "C:\Parsec-Cloud-Preparation-Tool\Parsec-Cloud-Preparation-Tool-master" -Argument "C:\Parsec-Cloud-Preparation-Tool\Parsec-Cloud-Preparation-Tool-master\Loader.ps1"
        $selfDestruct = New-ScheduledTaskAction -Execute powershell.exe -Argument "-Command `"Disable-ScheduledTask -TaskName $taskname`""
        Register-ScheduledTask -TaskName $taskname -Trigger $trigger -Action $action,$selfDestruct -RunLevel Highest
    }



# https://github.com/badjware/aws-cloud-gaming/blob/master/templates/user_data.tpl

      # https://github.com/jamesstringerparsec/Parsec-Cloud-Preparation-Tool
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $downloadPath = "C:\Parsec-Cloud-Preparation-Tool.zip"
    $extractPath = "C:\Parsec-Cloud-Preparation-Tool"
    $repoPath = Join-Path $extractPath "Parsec-Cloud-Preparation-Tool-master"
    $copyPath = Join-Path $desktopPath "ParsecTemp"
    $scriptEntrypoint = Join-Path $repoPath "PostInstall\PostInstall.ps1"
    if (!(Test-Path -Path $extractPath)) {
        [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
        (New-Object System.Net.WebClient).DownloadFile("https://github.com/jamesstringerparsec/Parsec-Cloud-Preparation-Tool/archive/master.zip", $downloadPath)
        New-Item -Path $extractPath -ItemType Directory
        Expand-Archive $downloadPath -DestinationPath $extractPath
        Remove-Item $downloadPath
        New-Item -Path $copyPath -ItemType Directory
        Copy-Item $repoPath/* $copyPath -Recurse -Container
        # Setup scheduled task to run Parsec-Cloud-Preparation-Tool once at logon
        $action = New-ScheduledTaskAction -Execute powershell.exe -WorkingDirectory $repoPath -Argument "-Command `"$scriptEntrypoint -DontPromptPasswordUpdateGPU`""
        run-once-on-login "Parsec-Cloud-Preparation-Tool" $action
    }