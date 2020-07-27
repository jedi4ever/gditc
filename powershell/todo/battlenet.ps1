    # download bnetlauncher
    (New-Object System.Net.WebClient).DownloadFile("http://madalien.com/pub/bnetlauncher/bnetlauncher_v18.zip", "c:\cloudygamer\downloads\bnetlauncher.zip")
    Expand-Archive -LiteralPath "c:\cloudygamer\downloads\bnetlauncher.zip" -DestinationPath "c:\cloudygamer\bnetlauncher"

    # download bnet (needs to be launched twice because of some error)
    (New-Object System.Net.WebClient).DownloadFile("https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP", "c:\cloudygamer\downloads\battlenet.exe")
    & c:\cloudygamer\downloads\battlenet.exe --lang=english
    sleep 25
    Stop-Process -Name "battlenet"
    & c:\cloudygamer\downloads\battlenet.exe --lang=english --bnetdir="c:\Program Files (x86)\Battle.net" | Out-Null