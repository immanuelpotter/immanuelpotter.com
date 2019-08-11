# immanuelpotter.com

## Forked from https://github.com/rosstimson/rosstimson.com
[rosstimson.com](https://rosstimson.com/)

Personal blog website.

### Pre-requisites

The Terraform assumes that a couple of AWS resources have been
pre-created and needs their IDs set as a variable:

* Route 53 hosted domain
* TLS certificate managed by ACM. Worth mentioning, to be used by CloudFront, the certificate needs requesting from Virginia (us-east-1); regardless of where you're creating the rest of your infra.
* Lambda@Edge function already created in us-east-1 - I'm using [this](https://github.com/immanuelpotter/lambda-edge-header-adder) for extra security

### AWS Infrastructure

Provision all the AWS infrastructure needed with:

    terraform apply -var duplicate_content_penalty_secret="$(pwgen -s 32 1)"

*Note:* The duplicate_content_penalty_secret is just a random string
so here I am using `pwgen` to create a 32 char string.
Running the apply without passing this var will prompt for a string.

### Uploading Site

One the infrastructure is ready the static site can be deployed by
using the AWS cli tools to upload files to the S3 bucket.  In order to
make this easier a simple `Makefile` is included which has the
following tasks:

`upload` - Uses `aws sync` to upload files to S3.

`invalidate-cache` - Invalidates all files in Cloudfront to make
changes take effect immediately.

## Credit

The Terraform has been largely taken from
https://github.com/ringods/terraform-website-s3-cloudfront-route53
with slight modifications to simplify it for my needs.

Again, slight modifications have been added as this is largely a fork from https://github.com/rosstimson/rosstimson.com - you can use this yourself by changing variables defined in `terraform/website.tf.autovars`.
