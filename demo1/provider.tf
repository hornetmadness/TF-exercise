provider "aws" {
    version = "~> 2.0"
}

terraform {
    backend "s3" {
        bucket = "terraform.erik.mathis"
        key    = "terraform.state"
        region = "us-east-1"
    }
}