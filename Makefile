EXEC=
TF_DIR=terraform

# Create the project dirs
dirs:
	mkdir -p tmp
	mkdir -p state

# initialize the terraform project
# this will also download the providers needed
init: dirs
	terraform init

# run a terraform plan
plan:
	$(EXEC) terraform plan -state=state/terraform.tfstate -out=tmp/tf-plan $(TF_DIR)

# run a terraform apply using the plan you just created
apply:
	$(EXEC) terraform apply -state=state/terraform.tfstate tmp/tf-plan

# refresh the terraform state , just in case
refresh:
	$(EXEC) terraform refresh -state=state/terraform.tfstate  $(TF_DIR)

# Place holder for the syntax on how to import an existing resource in the terraform state
import:
	$(EXEC) terraform import -config=$(TF_DIR) -state=state/terraform.tfstate  aws_iam_instance_profile.windows_instance_profile cloud-gaming-instance-profile

# Formats terraform files
fmt:
	terraform fmt

# Show the terrform output variabls
output:
	terraform output -state=state/terraform.tfstate

# Like vagrant up , do a plan , apply and provision
up: plan apply provision

# Remove your terraform setup
destroy:
	$(EXEC) terraform destroy -state=state/terraform.tfstate $(TF_DIR)

# Write your vm ip in a tempory file for easy access
# This allows us to run ssh scripts without having to run terraform output everytime
ip:
	terraform output -state=state/terraform.tfstate instance_ip > tmp/ip

# -t to make tab completion work
# stricthost to ignore keys everytime
# TODO : assumes your ssh key is loaded
ssh: ip
	ssh -t -o "StrictHostKeyChecking no" Administrator@$(shell cat tmp/ip) powershell

# Blindly trusts the ssh key from your remote vm/ip and updates your known_hosts
trust:
	ssh-keygen -R $(shell cat tmp/ip)
	ssh-keyscan -H $(shell cat tmp/ip) >> ~/.ssh/known_hosts

# Transfers your powershell script to the vm
sync: ip
	scp -r powershell/*.ps1 Administrator@$(shell cat tmp/ip):/scripts/

# WIP: use rsync instead of sync to make it faster
# TODO: figure out to get rsync working on the windows side
#rsync:
#	rsync -avz --rsync-path=/ProgramData/chocolatey/bin/rsync.exe powershell/*.ps1 Administrator@$(shell cat tmp/ip):/scripts/

# Runs the hello world script to see if it is working
hello: ip trust sync
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\hello.ps1'

# Provision all steps
# TODO: make this more granular
# Make it stop on error
provision:
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\chocolatey.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\7zip-install.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\audio-razer.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\install-directx.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\dot-net-core.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\directplay.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\enable-mousekeys.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\pointer-precision.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\aws-desktop-cleanup.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\aws-tools.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\googlechrome.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\set-time-timezone.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\server-manager.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\ie-security.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\nvidia.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\nvidia-faceworks-demo.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\devcon.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\xbox360-controller.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\disable-devices.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\parsec.ps1'
	ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\vigembus.ps1'
	#ssh -t Administrator@$(shell cat tmp/ip) 'powershell -File C:\scripts\steam.ps1'

# Caches the admin password for easy access
password:
	terraform output -state=state/terraform.tfstate Administrator_Password > tmp/password

# Creates an rdp shortcut to the instance
# And populates the password in our copy & paste buffer
# Note: windows remote desktop on mac does not allow for passwords in the rdp file
# TODO: other rdp clients might solve this

rdp:
	echo "auto connect:i:1" > vm.rdp
	echo "full address:s:$(shell cat tmp/ip)" >> vm.rdp
	echo "username:s:Administrator" >> vm.rdp
	cat tmp/password | tr -d '\n' | pbcopy
	open vm.rdp