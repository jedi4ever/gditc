#Creates shortcut for the GPU Updater tool
function gpu-update-shortcut {
    (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/parsec-cloud/Cloud-GPU-Updater/master/GPUUpdaterTool.ps1", "$ENV:Appdata\ParsecLoader\GPUUpdaterTool.ps1")
    Unblock-File -Path "$ENV:Appdata\ParsecLoader\GPUUpdaterTool.ps1"
    ProgressWriter -Status "Creating GPU Updater icon on Desktop" -PercentComplete $PercentComplete
    $Shell = New-Object -ComObject ("WScript.Shell")
    $ShortCut = $Shell.CreateShortcut("$path\GPU Updater.lnk")
    $ShortCut.TargetPath="powershell.exe"
    $ShortCut.Arguments='-ExecutionPolicy Bypass -File "%homepath%\AppData\Roaming\ParsecLoader\GPUUpdaterTool.ps1"'
    $ShortCut.WorkingDirectory = "$env:USERPROFILE\AppData\Roaming\ParsecLoader";
    $ShortCut.IconLocation = "$env:USERPROFILE\AppData\Roaming\ParsecLoader\GPU-Update.ico, 0";
    $ShortCut.WindowStyle = 0;
    $ShortCut.Description = "GPU Updater shortcut";
    $ShortCut.Save()
    }


    #Start GPU Update Tool
Function StartGPUUpdate {
    param(
    [switch]$DontPromptPasswordUpdateGPU
    )
    if ($DontPromptPasswordUpdateGPU) {
        }
    Else {
      start-process powershell.exe -verb RunAS -argument "-file $ENV:Appdata\ParsecLoader\GPUUpdaterTool.ps1"
        }
    }
Write-Host -foregroundcolor red "
                               ((//////                                
                             #######//////                             
                             ##########(/////.                         
                             #############(/////,                      
                             #################/////*                   
                             #######/############////.                 
                             #######/// ##########////                 
                             #######///    /#######///                 
                             #######///     #######///                 
                             #######///     #######///                 
                             #######////    #######///                 
                             ########////// #######///                 
                             ###########////#######///                 
                               ####################///                 
                                   ################///                 
                                     *#############///                 
                                         ##########///                 
                                            ######(*                   
                                                           
                           
                                       
                    ~Parsec Self Hosted Cloud Setup Script~
                    This script sets up your cloud computer
                    with a bunch of settings and drivers
                    to make your life easier.  
                    
                    It's provided with no warranty, 
                    so use it at your own risk.
                    
                    Check out the README.md for more
                    information.
                    This tool supports:
                    OS:
                    Server 2016
                    Server 2019
                    
                    CLOUD SKU:
                    AWS G3.4xLarge    (Tesla M60)
                    AWS G2.2xLarge    (GRID K520)
                    AWS G4dn.xLarge   (Tesla T4 with vGaming driver)
                    Azure NV6         (Tesla M60)
                    Paperspace P4000  (Quadro P4000)
                    Paperspace P5000  (Quadro P5000)
                    Google P100 VW    (Tesla P100 Virtual Workstation)
                    Google P4  VW    (Tesla P4 Virtual Workstation)
                    Google T4  VW    (Tesla T4 Virtual Workstation)
"   
PromptUserAutoLogon -DontPromptPasswordUpdateGPU:$DontPromptPasswordUpdateGPU
$ScripttaskList = @(
"setupEnvironment";
"addRegItems";
"create-directories";
"disable-iesecurity";
"download-resources";
"install-windows-features";
"set-update-policy";
"force-close-apps";
"disable-network-window";
"disable-logout";
"disable-lock";
"show-hidden-items";
"show-file-extensions";
"enhance-pointer-precision";
"enable-mousekeys";
"set-time";
"set-wallpaper";
"Create-AutoShutdown-Shortcut";
"Create-One-Hour-Warning-Shortcut";
"disable-server-manager";
"Install-Gaming-Apps";
"Server2019Controller";
"gpu-update-shortcut";
"disable-devices";
"clean-up";
"clean-up-recent";
"provider-specific"
)

foreach ($func in $ScripttaskList) {
    $PercentComplete =$($ScriptTaskList.IndexOf($func) / $ScripttaskList.Count * 100)
    & $func $PercentComplete
    }

StartGPUUpdate -DontPromptPasswordUpdateGPU:$DontPromptPasswordUpdateGPU
ProgressWriter -status "Done" -percentcomplete 100
Write-Host "1. Open Parsec and sign in" -ForegroundColor black -BackgroundColor Green 
Write-Host "2. Use GPU Updater to update your GPU Drivers!" -ForegroundColor black -BackgroundColor Green 
Write-Host "You don't need to sign into Razer Synapse" -ForegroundColor black -BackgroundColor Green 
Write-host "DONE!" -ForegroundColor black -BackgroundColor Green 
pause