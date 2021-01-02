# Spot instance to start
# We use the spot_type persistent so it can survive stops

resource "aws_spot_instance_request" "windows_instance" {
  instance_type        = var.instance_type
  availability_zone    = local.availability_zone
  ami                  = (length(var.custom_ami) > 0) ? var.custom_ami : data.aws_ami.windows_ami.image_id
  security_groups      = [aws_security_group.default.name]
  user_data            = templatefile("${path.module}/../templates/user_data_template.ps1", { password_ssm_parameter = aws_ssm_parameter.password.name })
  iam_instance_profile = aws_iam_instance_profile.windows_instance_profile.id

  # Spot configuration
  #spot_type = "one-time"
  spot_type            = "persistent"
  wait_for_fulfillment = true

  get_password_data = true
  key_name          = var.key_name

  # EBS configuration
  ebs_optimized = true
  root_block_device {
    volume_size = var.root_block_device_size_gb
  }

  tags = {
    Name = "cloud-gaming-instance"
    App  = "aws-cloud-gaming"
  }
}
