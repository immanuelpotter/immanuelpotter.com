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

variable "domain" {
  description = "The domain name for website. Example: rosstimson.com"
}

variable "domain_alias" {
  description = "Domain name alias for website. Example: www.rosstimson.com"
}

variable "duplicate_content_penalty_secret" {
  description = "Random string used to allow only CloudFront to access your S3 Bucket."
}

variable "cloudfront_price_class" {
  description = "CloudFront price class"
  default     = "PriceClass_200"
}

variable "forward_query_string" {
  description = "Forward the query string to the origin."
  default     = false
}

variable "acm_certificate_arn" {
  description = "ARN of TLS certificate in ACM."
}

variable "route53_zone_id" {
  description = "The Route53 Zone ID where the DNS entries must be created."
}
