# Left overs
# TODO: attach an additional disk (SSD) to the instance for storing games

/*
resource "aws_volume_attachment" "ebs_att" {
  device_name = "xvdf"
  volume_id   = var.game_ebs_volume_id
  instance_id = aws_spot_instance_request.windows_instance.spot_instance_id
}
*/
