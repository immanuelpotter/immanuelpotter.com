# rosstimson.com

[rosstimson.com](https://rosstimson.com/)

My personal website that links to my other places on the web.

## Deploy

### Pre-requisites

The Terraform assumes that a couple of AWS resources have been
pre-created and needs their IDs set as a variable:

* Route 53 hosted domain, in my case this is rosstimson.com
* TLS certificate managed by ACM.

### AWS Infrastructure

Provision all the AWS infrastructure needed with:

    terraform apply -var duplicate_content_penalty_secret="$(pwgen -s 32 1)"

*Note:* The duplicate_content_penalty_secret is just a random string
so here I am using `pwgen` to create a 32 char string.

### Uploading Site

One the infrastructure is ready the static site can be deployed by
using the AWS cli tools to upload files to the S3 bucket.  In order to
make this easier a simple `Makefile` is included which has the
following tasks:

`upload` - Uses `aws sync` to upload files to S3.

`invalidate-cache` - Invalidates all files in Cloudfront to make
changes take effect immediately.

`pretty` - Uses [Prettier](https://prettier.io/) to tidy us the HTML,
*note* this writes in-place.

## Credit

The Terraform has been largely taken from
https://github.com/ringods/terraform-website-s3-cloudfront-route53
with slight modifications to simplify it for my needs.
