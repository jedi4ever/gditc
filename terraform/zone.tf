locals {
  availability_zone = "${var.region}${element(var.allowed_availability_zone_identifier, random_integer.az_id.result)}"
}

resource "random_integer" "az_id" {
  min = 0
  max = length(var.allowed_availability_zone_identifier)
}
