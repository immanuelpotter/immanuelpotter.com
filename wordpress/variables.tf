variable "region" {
  description = "The AWS region."
}

variable "shared_creds_file" {
  description = "The AWS credentials file."
  default     = "~/.aws/credentials"
}

variable "profile" {
  description = "The AWS profile to use."
}

variable "instance_name" {
  description = "Name of the lightsail instance"
}

variable "blueprint_id" {
  description = "App to launch in lightsail"
}

variable "bundle_id" {
  description = "Blueprint ID to use in lightsail, instance size essentially"
}

variable "key_pair_name" {
  description = "SSH Keyname to use"
}

variable "hosted_zone" {
  description = "Pre-made Hosted Zone"
}
