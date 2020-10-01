module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "1.12.0"
  bucket  = "aws-sample-terraform-state"
  acl     = "private"

  versioning = {
    enabled = true
  }
}