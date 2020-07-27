#Create ParsecTemp folder in C Drive
function create-directories {
    ProgressWriter -Status "Creating Directories (C:\ParsecTemp)" -PercentComplete $PercentComplete
    if((Test-Path -Path C:\ParsecTemp) -eq $true) {} Else {New-Item -Path C:\ParsecTemp -ItemType directory | Out-Null}
    if((Test-Path -Path C:\ParsecTemp\Apps) -eq $true) {} Else {New-Item -Path C:\ParsecTemp\Apps -ItemType directory | Out-Null}
    if((Test-Path -Path C:\ParsecTemp\DirectX) -eq $true) {} Else {New-Item -Path C:\ParsecTemp\DirectX -ItemType directory | Out-Null}
    if((Test-Path -Path C:\ParsecTemp\Drivers) -eq $true) {} Else {New-Item -Path C:\ParsecTemp\Drivers -ItemType Directory | Out-Null}
    if((Test-Path -Path C:\ParsecTemp\Devcon) -eq $true) {} Else {New-Item -Path C:\ParsecTemp\Devcon -ItemType Directory | Out-Null}
    }