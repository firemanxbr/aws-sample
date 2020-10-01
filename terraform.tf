terraform {
  required_version = "~> 0.13"

  backend "s3" {
    bucket               = "aws-sample-terraform-state"
    key                  = "tf-state.json"
    region               = "us-east-1"
    workspace_key_prefix = "environment"
  }
}