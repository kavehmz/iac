    terraform {
    backend "s3" {
        bucket = "deriv-playground-iac-states"
        key    = "aws/personal/project_a/"
        region = "us-east-1"
    }
    }
