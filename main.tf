module "ec2" {
  count = var.ec2.create ? 1 : 0
  source = "./modules/ec2"
  ec2 = var.ec2.instances
  ami     = var.ec2.ami
  instance_type = var.ec2.instances.instance_type
  associate_public_ip_address = var.ec2.instances.associate_public_ip_address
  volume_size = var.ec2.instances.volume_size
  subnet_id = module.vpc[0].subnets
  instance_profile = var.ec2.instances.instance_profile
  cidr = var.vpc.on_use.cidr
  vpc_id = module.vpc
  project_name    = var.project_name
  PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
  PROJECT_ENV = var.PROJECT_ENV
  depends_on = [module.key_pair]
  
}
module "key_pair" {
  count = var.key_pair.create ? 1 : 0
  source = "./modules/key_pair"
  keys = var.key_pair.keys
  project_name    = var.project_name
  PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
  PROJECT_ENV = var.PROJECT_ENV 
  
}
module "ecr" {
  count = var.ecr.create ? 1 : 0
  source       = "./modules/ecr"
  ecr = var.ecr
  project_name    = var.project_name
  PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
  PROJECT_ENV = var.PROJECT_ENV 
}
module "eks" {
  count = var.eks.create ? 1 : 0
  source                = "./modules/eks"
  private_subnets            = module.vpc[0].private_subnets
  fargate_namespace_1   = var.eks.fargate_namespace_1
  fargate_namespace_2   = var.eks.fargate_namespace_2
  fargate_namespace_3   = var.eks.fargate_namespace_3
  fargate_namespace_4   = var.eks.fargate_namespace_4
  fargate_namespace_5   = var.eks.fargate_namespace_5
  aws_eks_cluster_version = var.eks.aws_eks_cluster_version
  cidr = var.vpc.on_use.cidr
  vpc_id = module.vpc
  project_name    = var.project_name
  PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
  PROJECT_ENV = var.PROJECT_ENV
}

module "api-gateway" {
  count = var.api-gateway.create ? 1 : 0
  source                = "./modules/api-gateway"
  certificate_arn       = var.api-gateway.certificate_arn
  security_group_ids = module.eks[0].sg_eks
  subnet_ids = module.vpc[0].private_subnets
  integration_uri = var.api-gateway.integration_uri
  domain_name = var.api-gateway.domain_name
  hosted_zone_id = var.api-gateway.hosted_zone_id
  project_name    = var.project_name
  PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
  PROJECT_ENV = var.PROJECT_ENV
  depends_on       = [module.eks]

}

module "msk" {
    count = var.msk.create ? 1 : 0
    source = "./modules/msk"
    subnet_ids         = module.vpc[0].private_subnets
    number_of_broker_nodes = var.msk.number_of_broker_nodes
    instance_type = var.msk.instance_type
    volume_size = var.msk.volume_size
    cidr = var.vpc.on_use.cidr
    vpc_id = module.vpc
    project_name    = var.project_name
    PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
    PROJECT_ENV = var.PROJECT_ENV 
}
module "rds" {
    count = var.rds.create ? 1 : 0
    source = "./modules/rds"
    db_name     = var.rds.db_name
    engine      = var.rds.engine
    engine_version = var.rds.engine_version
    instance_class = var.rds.instance_class
    username   = var.rds.username
    password   = var.rds.password
    parameter_group_name  = var.rds.parameter_group_name
    subnet_ids = module.vpc[0].private_subnets
    rds_allocated_storage = var.rds.rds_allocated_storage
    rds_max_allocated_storage = var.rds.rds_max_allocated_storage
    cidr = var.vpc.on_use.cidr
    vpc_id = module.vpc
    project_name    = var.project_name
    PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
    PROJECT_ENV = var.PROJECT_ENV
}
module "s3" {
     count = var.s3.create ? 1 : 0
     source = "./modules/s3"
     names = var.s3.names
     project_name    = var.project_name
     PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
     PROJECT_ENV = var.PROJECT_ENV
}

module "redis" {
    count = var.redis.create ? 1 : 0
    source = "./modules/redis"
    redis_engine_version    =   var.redis.redis_engine_version
    redis_node    =   var.redis.redis_node
    redis_num_shards    =   var.redis.redis_num_shards 
    redis_num_replicas_per_shard    =   var.redis.redis_num_replicas_per_shard
    redis_snapshot_retention_limit    =   var.redis.redis_snapshot_retention_limit
    cidr = var.vpc.on_use.cidr
    vpc_id = module.vpc
    project_name    = var.project_name
    PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
    PROJECT_ENV = var.PROJECT_ENV 
    subnet_ids = [module.vpc[0].private_subnets[0], module.vpc[0].private_subnets[1]]
}

module "secrets-manager" {
  count = var.secrets-manager.create ? 1 : 0
  source = "./modules/secrets-manager"
  keys = var.key_pair.keys
  secret_string = module.key_pair.tls_private_key[each.key]
  project_name    = var.project_name
  PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
  PROJECT_ENV = var.PROJECT_ENV
  depends_on = [module.key_pair]
}

module "vpc" {
  count = var.vpc.create ? 1 : 0
  source = "terraform-aws-modules/vpc/aws"
  cidr = var.vpc.on_use.cidr
  azs = var.vpc.on_use.azs
  public_subnets = var.vpc.on_use.subnets.public
  private_subnets = var.vpc.on_use.subnets.private
}