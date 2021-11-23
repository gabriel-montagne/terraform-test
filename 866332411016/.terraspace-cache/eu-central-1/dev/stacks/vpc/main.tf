module "vpc" {
  source             = "../../modules/vpc"
  dtap               = "dev"
  single_nat_gateway = true
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
}

module "bastion" {
  source             = "../../modules/bastion"
  dtap               = "dev"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  authorized_keys    = var.authorized_keys
}
