# Provider
# -----------------------------------------------------------------------------

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.shared_creds_file}"
  profile                 = "${var.profile}"
}

# S3 Bucket
# -----------------------------------------------------------------------------

data "template_file" "bucket_policy" {
  template = "${file("${path.module}/website_bucket_policy.json")}"
  
  vars = {
    bucket = "${var.domain}"
    secret = "${var.duplicate_content_penalty_secret}"
  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.domain}"
  policy = "${data.template_file.bucket_policy.rendered}"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = {
    Name      = "${var.domain} Website Bucket"
    Terraform = "true"
  }
}

# Cloudfront
# -----------------------------------------------------------------------------

resource "aws_cloudfront_distribution" "website_cdn" {
  enabled     = true
  price_class = "${var.cloudfront_price_class}"

  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.website_bucket.id}"
    domain_name = "${aws_s3_bucket.website_bucket.website_endpoint}"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    custom_header {
      name  = "User-Agent"
      value = "${var.duplicate_content_penalty_secret}"
    }
  }

  default_root_object = "index.html"

   default_cache_behavior  {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

     forwarded_values  {
      query_string = "${var.forward_query_string}"

      cookies {
        forward = "none"
      }
    }

    target_origin_id = "origin-bucket-${aws_s3_bucket.website_bucket.id}"

    // This redirects any HTTP request to HTTPS.
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

   restrictions  {
     geo_restriction  {
      restriction_type = "none"
    }
  }

   viewer_certificate  {
    acm_certificate_arn      = "${var.acm_certificate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  aliases = ["${var.domain}", "${var.domain_alias}"]

  tags = {
    Name      = "${var.domain} Website CDN"
    Terraform = "true"
  }
}

# Cloudfront
# -----------------------------------------------------------------------------

# For non-root domain (i.e. the www. alias).
resource "aws_route53_record" "cdn_cname" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.domain_alias}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_cloudfront_distribution.website_cdn.domain_name}"]
}

# For the root domain.
resource "aws_route53_record" "cdn_alias" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.website_cdn.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website_cdn.hosted_zone_id}"
    evaluate_target_health = false
  }
}
