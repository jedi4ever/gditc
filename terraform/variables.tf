variable "region" {
  description = "The aws region."
  type        = string
  default     = "eu-west-1"
}

variable "allowed_availability_zone_identifier" {
  description = "The allowed availability zone identify (the letter suffixing the region)."
  type        = list(string)
  default     = ["a", "b"]
}

variable "instance_type" {
  description = "The aws instance type"
  type        = string
  default     = "g4dn.xlarge"
}

variable "root_block_device_size_gb" {
  description = "The size of the root block device (C:\\ drive) attached to the instance"
  type        = number
  default     = 120
}

variable "game_ebs_volume_id" {
  description = "The Persistent EBS Volume ID for the game drive"
  type        = string
  default     = ""
}

variable "custom_ami" {
  description = "Custom AMI (For Post First Run)"
  type        = string
  default     = ""
}

variable "key_name" {
  default = "cloudgaming"
}

