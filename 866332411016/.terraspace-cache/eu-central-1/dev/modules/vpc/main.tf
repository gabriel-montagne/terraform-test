module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  version = "~> 3.10.0"

  name = var.dtap
  cidr = var.cidr

  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway
  one_nat_gateway_per_az = false
  enable_dns_hostnames = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = var.dtap
  }
}
