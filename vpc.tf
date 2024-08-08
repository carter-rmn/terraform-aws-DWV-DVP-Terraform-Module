module "vpc" {
count = var.vpc.vpc.create ? 1 : 0
source = "terraform-aws-modules/vpc/aws"

  name = var.vpc.vpc_name
  cidr = var.vpc.vpc_cidr

  azs             = var.vpc.azs
  private_subnets = var.vpc.private_subnets
  public_subnets  = var.vpc.public_subnets
  enable_dns_hostnames = var.vpc.enable_dns_hostnames
  enable_dns_support   = var.vpc.enable_dns_support
  enable_vpn_gateway = var.vpc.enable_vpn_gateway
  enable_nat_gateway  = var.vpc.enable_nat_gateway
  single_nat_gateway  = var.vpc.single_nat_gateway
  one_nat_gateway_per_az = var.vpc.one_nat_gateway_per_az

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}