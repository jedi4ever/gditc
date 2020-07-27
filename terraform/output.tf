# Variables we want to know
# TODO : cleanup passwords, it's confusing now
# instance_password : our own random generated password
# Administrator_password: the one created by AWS using our keypair

output "instance_id" {
  value = aws_spot_instance_request.windows_instance.id
}

output "spot_instance_id" {
  value = aws_spot_instance_request.windows_instance.spot_instance_id
}

output "instance_ip" {
  value = aws_spot_instance_request.windows_instance.public_ip
}

output "instance_password" {
  value     = random_password.password.result
  sensitive = true
}

output "Administrator_Password" {
  value = "${rsadecrypt(aws_spot_instance_request.windows_instance.password_data, "${tls_private_key.example.private_key_pem}")}"
}
