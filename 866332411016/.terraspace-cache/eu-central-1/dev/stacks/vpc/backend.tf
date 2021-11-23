terraform {
  backend "s3" {
    bucket         = "terraform-state-288104454192-eu-central-1-dev"
    key            = "eu-central-1/dev/stacks/vpc/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}
