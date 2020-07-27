# Prepares the machine to have automated ssh access
# The connection is done over winrm (enabled via user_data script)
# TODO : winrm is currently not encryped
# TODO : maybe we can go directly over ssh as ssh is enabled in userdata too?

resource "null_resource" "prepare_ssh" {

  triggers = {
    # Makes this script trigger everytime
    version = "${timestamp()}"
  }

  depends_on = [aws_spot_instance_request.windows_instance]

  connection {
    type     = "winrm"
    https    = false
    insecure = true
    user     = "Administrator"
    password = "${rsadecrypt(aws_spot_instance_request.windows_instance.password_data, "${tls_private_key.example.private_key_pem}")}"

    host = "${aws_spot_instance_request.windows_instance.public_ip}"
    port = "5985"
  }

  # Transfer sshd setup script 
  provisioner "file" {
    source      = "powershell/sshd.ps1"
    destination = "C:\\scripts\\sshd.ps1"
  }

  # Setup script to set correct file permissions on authorized_keys
  provisioner "file" {
    source      = "powershell/ssh_authorized_keys.ps1"
    destination = "C:\\scripts\\ssh_authorized_keys.ps1"
  }

  # Setup our public key
  provisioner "file" {
    source      = "id_rsa.pub"
    destination = "C:\\ProgramData\\ssh\\administrators_authorized_keys"
  }

  # setup the powershell profile (to have chocolatey in path)
  # TODO move elsewhere
  provisioner "file" {
    source      = "powershell/profile.ps1"
    destination = "C:\\Users\\Administrator\\My Documents\\WindowsPowershell\\profile.ps1"
  }

  # Enable SShd & correct authorized_keys
  provisioner "remote-exec" {

    inline = [
      "powershell.exe -Command Start-Process -Wait PowerShell -ArgumentList '-File C:\\scripts\\sshd.ps1' -Verb RunAs",
      "powershell.exe -Command Start-Process -Wait PowerShell -ArgumentList '-File C:\\scripts\\ssh_authorized_keys.ps1' -Verb RunAs",
    ]

  }

}
