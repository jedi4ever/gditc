# Limit the network access to our vm
# Depends on what remote access we are using
# Currently: rdp, winrm, ssh , parsec, steam streaming , virtual desktop
# Limited from our IP only

resource "aws_security_group" "default" {
  name = "cloud-gaming-sg"

  tags = {
    App = "aws-cloud-gaming"
  }
}

# Allow rdp connections from the local ip
resource "aws_security_group_rule" "rdp_ingress" {
  type              = "ingress"
  description       = "Allow rdp connections (port 3389)"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["${data.external.local_ip.result.ip}/32"]
  security_group_id = aws_security_group.default.id
}

# Allow winrm connections from the local ip
resource "aws_security_group_rule" "winrm_ingress" {
  type              = "ingress"
  description       = "Allow winrm connections (port 5987-5986)"
  from_port         = 5985
  to_port           = 5986
  protocol          = "tcp"
  cidr_blocks       = ["${data.external.local_ip.result.ip}/32"]
  security_group_id = aws_security_group.default.id
}

# Allow ssh connections from the local ip
resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  description       = "Allow ssh connections (22)"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${data.external.local_ip.result.ip}/32"]
  security_group_id = aws_security_group.default.id
}

# Allow vnc connections from the local ip
resource "aws_security_group_rule" "vnc_ingress" {
  type              = "ingress"
  description       = "Allow vnc connections (port 5900)"
  from_port         = 5900
  to_port           = 5900
  protocol          = "tcp"
  cidr_blocks       = ["${data.external.local_ip.result.ip}/32"]
  security_group_id = aws_security_group.default.id
}

# Allow rdp connections from the local ip
resource "aws_security_group_rule" "parsec_ingress" {
  type              = "ingress"
  description       = "Allow Parsec connections (port 8000-8040)"
  from_port         = 8000
  to_port           = 8040
  protocol          = "udp"
  cidr_blocks       = ["${data.external.local_ip.result.ip}/32"]
  security_group_id = aws_security_group.default.id
}

# Allow outbound connection to everywhere
resource "aws_security_group_rule" "default" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

# Allow steam stream
resource "aws_security_group_rule" "steam_stream_udp_ingress" {
  type              = "ingress"
  description       = "Allow Steam Streaming connections (port UDP 27031-270036)"
  from_port         = 27031
  to_port           = 27036
  protocol          = "udp"
  cidr_blocks       = ["${data.external.local_ip.result.ip}/32"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "steam_stream_tcp_ingress" {
  type              = "ingress"
  description       = "Allow Steam Streaming connections (port TCP 27036-270037)"
  from_port         = 27036
  to_port           = 27037
  protocol          = "tcp"
  cidr_blocks       = ["${data.external.local_ip.result.ip}/32"]
  security_group_id = aws_security_group.default.id
}

# VR Desktop
resource "aws_security_group_rule" "virtual_desktop_tcp_ingress" {
  type              = "ingress"
  description       = "Allow Virtual Desktop Streaming connections (port TCP 38810-38840)"
  from_port         = 38810
  to_port           = 38840
  protocol          = "tcp"
  cidr_blocks       = ["${data.external.local_ip.result.ip}/32"]
  security_group_id = aws_security_group.default.id
}

# NICE DCV
resource "aws_security_group_rule" "nice_dcv_tcp_ingress" {
  type              = "ingress"
  description       = "Allow Nice DCV port"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = ["${data.external.local_ip.result.ip}/32"]
  security_group_id = aws_security_group.default.id
}
