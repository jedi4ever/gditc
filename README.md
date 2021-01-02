# GDITC

> Aka `Gaming Desktop In The Cloud`
> Aka `Gpu Desktop In The Cloud`

Note :

- this is not 100% cleaned up yet , it works for me right now but I have to square away some quirks
- but I thought it was useful to share already

## Why

There a good repos available but I (personally) have the following goals:

- fully understand the code I executed : basically me disecting the powershell scripts and dependencies + documenting it
- restrict permissions as much as I can : seems most don't care, but I do care
- don't depend on unknown 3rd party download of tools - only use official sources: well ... it's obvious why
- make it useful beyond gaming : f.i. streaming , gaming development all could benefit from a cloud vm
- provide an easy way to override, customize the scripts : instead of having to fork it
- make it work on multiple (gpu/gaming) clouds
- make it easy to turn this into an image/ami
- turn this into a library of different install profiles
- turn this into an easy/cli UI program for everyone to use

## Inspiration

I owe the following repos deeply:

### AWS (Current focus)

- <https://github.com/jamesstringerparsec> : amazing polishing work to get things working on windows 2019 and others using parsec
- <https://github.com/parsec-cloud/Cloud-GPU-Updater/blob/master/GPUUpdaterTool.ps1> : for installing the drivers on gpus
- <https://github.com/badjware/aws-cloud-gaming/> : for making it into a terraform module
- <https://github.com/russiansmack/galaxy> : for looking at ways to automate steam
- <https://github.com/domenickp/gamingaws-terraform>
- <https://www.youtube.com/watch?v=BtVbBlZ27uI> : nice video series about setting up your aws cloud gaming server

Older:

- <https://github.com/lg/cloudy-gamer> : the (old) original cloud gaming repo that showed us how it could be done
- <https://www.cloudar.be/awsblog/how-to-use-aws-ec2-gpu-instances/>
- <https://github.com/LGUG2Z/parsec-ec2>

### Azure

- <https://github.com/nyanhp/AzureCloudGaming/>
- <https://github.com/hjb1/azureParsecCloudGaming>
- <https://github.com/nVentiveUX/azure-gaming/>
- <https://github.com/SamStenton/azure-gaming>
- <https://github.com/hjb1/azureParsecCloudGaming>
- <https://github.com/alliallfrey/vm-gamestream>

### Google Cloud

- <https://github.com/putty182/gcloudrig>
- <https://github.com/aykamko/parsec-google-cloud-gaming>

### Unreal
- <https://github.com/aws-samples/deploying-unreal-engine-pixel-streaming-server-on-ec2>
- <https://github.com/jmarymee/Unreal-Pixel-Streaming-on-Azure/tree/main/iac>

## Technical Notes

### Terraform

- this currently uses Terraform 12
- if using aws-vault you need to store your key with -no-session as temporary keys without MFA don't play well with iam profiles
- TODO: turn this into a TF module

### AWS

- persistent spot instances are used to make them survive stops
- spot instances for g4.2xlarge might require you to increase your limits of spotinstances (can not fullfill)
- vcpuLimitExceeded also needs to be increased
- we use a temporary key to create the windows instances
- TODO: permissions are too open right now (s3, ssm)

### Windows

- current we activate winrm in user_data
- then transfer files to the instance using winrm to enable ssh
- then we continue using ssh to execute scripts in powershell

### Software

- Remote access: Win RM , SSH , RDP , Parsec (looking into moonlight & vnc)
- Display : NVIDIA Drivers
- Audio: Razer (looking into Virtual Cable)
- USB: Vigembus (looking into Virtual Here, Flexihub), windows Redirect FX
- Gamepad: Xbox compatible over Parsec
- VPN: (looking into ZeroTier)
- Game play: Steam , Battlenet, Epic Games
- Apps : (looking into Skype, OBS , Unreal Engine)
