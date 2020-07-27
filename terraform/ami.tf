# AMI to use
# We use the windows 2019 Server edition

data "aws_ami" "windows_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}
