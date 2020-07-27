# permissions our system will have 
# TODO - restrict more
# - SSM access to get the password
# - S3 access to get the nvidia drivers from the nvidia bucket (official)

resource "aws_iam_role" "windows_instance_role" {
  name               = "cloud-gaming-instance-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    App = "aws-cloud-gaming"
  }
}

resource "aws_iam_policy" "password_get_parameter_policy" {
  name   = "password-get-parameter-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ssm:GetParameter",
      "Resource": "${aws_ssm_parameter.password.arn}"
    }
  ]
}
EOF
}
resource "aws_iam_policy" "driver_get_object_policy" {
  name   = "driver-get-object-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "password_get_parameter_policy_attachment" {
  role       = aws_iam_role.windows_instance_role.name
  policy_arn = aws_iam_policy.password_get_parameter_policy.arn
}

resource "aws_iam_role_policy_attachment" "driver_get_object_policy_attachment" {
  role       = aws_iam_role.windows_instance_role.name
  policy_arn = aws_iam_policy.driver_get_object_policy.arn
}

resource "aws_iam_instance_profile" "windows_instance_profile" {
  name = "cloud-gaming-instance-profile"
  role = aws_iam_role.windows_instance_role.name
}
