# We create our own password

resource "random_password" "password" {
  length  = 32
  special = true
}

resource "aws_ssm_parameter" "password" {
  name  = "cloud-gaming-administrator-password"
  type  = "SecureString"
  value = random_password.password.result

  tags = {
    App = "aws-cloud-gaming"
  }
}
