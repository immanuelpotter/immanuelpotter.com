# S3 remote state

terraform {
  backend "s3" {
    bucket = "mannys-fun-stuff"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.shared_creds_file}"
  profile                 = "${var.profile}"
}

resource "aws_lightsail_instance" "wordpress" {
  name              = "${var.instance_name}"
  availability_zone = "${var.region}a"
  blueprint_id      = "${var.blueprint_id}"
  bundle_id         = "${var.bundle_id}"
  key_pair_name     = "${var.key_pair_name}"
}

resource "aws_lightsail_static_ip" "wordpress_static_ip" {
  name = "wordpress-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "static_ip_attachment" {
  static_ip_name = "${aws_lightsail_static_ip.wordpress_static_ip.name}"
  instance_name  = "${aws_lightsail_instance.wordpress.name}"
}

resource "aws_route53_record" "wordpress" {
  zone_id = "${var.hosted_zone}"
  name    = "immanuelpotter.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_lightsail_static_ip.wordpress_static_ip.ip_address}"]
}

resource "aws_route53_record" "wordpress_cname" {
  zone_id = "${var.hosted_zone}"
  name    = "www.immanuelpotter.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_route53_record.wordpress.name}"]
}

output "public_ip" {
  value = "${aws_lightsail_static_ip.wordpress_static_ip.ip_address}"
}
