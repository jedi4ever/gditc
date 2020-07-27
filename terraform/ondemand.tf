# Preparation to use a permanent instance instead of a spot_instance

/*
resource "aws_instance" "windows_instance" {
  ami                  = (length(var.custom_ami) > 0) ? var.custom_ami : data.aws_ami.windows_ami.image_id
  instance_type        = var.instance_type
  availability_zone    = local.availability_zone
  security_groups      = [aws_security_group.default.name]
  user_data            = templatefile("${path.module}/templates/user_data_template.ps1", { password_ssm_parameter = aws_ssm_parameter.password.name })
  iam_instance_profile = aws_iam_instance_profile.windows_instance_profile.id

  # EBS configuration
  ebs_optimized = true
  root_block_device {
    volume_size = var.root_block_device_size_gb
  }

  tags = {
    Name = "cloud-gaming-instance"
    App  = "aws-cloud-gaming"
  }

  get_password_data = true
  key_name          = "${var.key_name}"

}

*/
