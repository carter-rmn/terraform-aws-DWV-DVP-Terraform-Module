# module "vpc" {
#   count = var.vpc.create ? 1 : 0
#   source = "terraform-aws-modules/vpc/aws"
#   cidr = var.vpc.on_use.cidr
#   azs = var.vpc.on_use.azs
#   public_subnets = var.vpc.on_use.subnets.public
#   private_subnets = var.vpc.on_use.subnets.private
# }

