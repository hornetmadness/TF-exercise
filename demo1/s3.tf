resource "aws_s3_bucket" "terraform" {
    bucket = "terraform.erik.mathis"
    acl    = "private"

    tags = {
        Name = "Terraform"
    }
    versioning {
        enabled = true
    }
}
