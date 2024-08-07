variable "PROJECT_CUSTOMER" {}
variable "PROJECT_ENV" {}

variable "vpc" {
    type = object({
      create =  bool
      vpc_name = string
      vpc_cidr = string
      azs = list(string)
      private_subnets = list(string)
      public_subnets = list(string)
      enable_dns_hostname = bool
      enable_dns_support = bool
      enable_vpn_gateway = bool
      enable_nat_gateway = bool
      single_nat_gateway = bool
      ne_nat_gateway_per_az = bool
    })
  
}
variable "msk" {
    type = object({
      create = bool
      msk_cluster = string
      volume_size = number
      number_of_broker_nodes = number
      instance_type = string
      security_group = list(string)
      subnet_ids = list(string)
      msk_cloudwatch_log_group = string
      msk_config = string
    })
  
}
variable "data-weaver-ec2-instance" {
    type = object({
      create = bool
      ami = string
      instance_type = string
      instance_name = string
      subnet_id = string
      key_name = string
      volume_size = number
      volume_type = string
      security_group_id = list(string)
      instance_profile = string
      ebs_name = string
    })
}
variable "secrets-manager" {
    type = object({
      create = bool
      secret_name = string
      secret_string = string
    })
  
}
variable "eks" {
    type = object({
      create = bool
      environment = string
      cluster_name = string
      private_id = list(string)
      fargate_namespace_1 = string
      fargate_namespace_2 = string
      fargate_namespace_3 = string
      fargate_namespace_4 = string
      fargate_namespace_5 = string
      eks_role_name = string
      aws_eks_cluster_version = string

    })
}
variable "ecs" {
  type = object({
    create = bool
    ecs_sg = string
    container_name = string
    load_balancer = string
    targate_group = string
    vpc_id = string
    private_subnet = list(string)
    ecr_url = string
    ecr_web_url = string
    certificate_arn = string
    eks_sg = string
    stage-name = string
    api-gateway-name = string
    security_group_ids = list(string)
    subnet_ids = list(string)
    domain_name = string
    hosted_zone_id = string
    vpc-link-name = string
  })
  
}
variable "ecr" {
    type = object({
      create = bool
      ecrname_builder = string
      ecrname_management = string
      ecrname_connector = string
      ecrname_fe = string
      imagetag = string
      ecrname_test_builder = string
      ecrname_test_management = string
      ecrname_test_connector = string
      ecrname_test_fe = string
      ecrname_odin = string
      ecrname_web = string
      ecrname_scheduler = string
      ecrname_odin_executor_rmn = string
      ecrname_odin_web_rmn = string
      ecrname_odin_scheduler_rmn = string
    })
  
}


variable "ec2-instance" {
    type = object({
      create = bool
      instance_ami = string
      instance_type = string
      instance_name_1 = string
      instance_name_2 = string
      subnet_id = string
      vpc_security_group_ids = list(string)
      key_name = string
      filename = string
      volume_size = number
      volume_type = string
      bucket_name = string
    })
  
}
variable "rds" {
    type = object({
      create = bool
      db_name = string
      engine = string
      engine_version = string
      identifier = string
      instance_class = string
      username = string
      password = string
      parameter_group_name = string
      db_subnet_group = string
      security_group = list(string)
      subnet_ids = list(string)
      rds_allocated_storage = number
      rds_max_allocated_storage = number
      rds_backup_retention_period = number
    })
  
}
variable "s3" {
    type = object({
      create = bool
      bucket_name_1 = string
    })
  
}
variable "redis" {
    type = object({
      create = bool
      redis_sg = string
      redis_name = string
      redis_engine_version = string
      redis_node = string
      redis_num_shards = number
      redis_num_replicas_per_shard = number
      eks_sg = string
      redis_snapshot_retention_limit = number
      subnet_ids = list(string)
    })
  
}
variable "api-gateway" {
    type = object({
      create = bool
      odin_rmn_web_certificate_arn = string
      odin-rmn-stage-name = string
      odin-rmn-api-gateway-name = string
      odin_rmn_domain_name = string
      hosted_zone_id = string
      odin-rmn-vpc-link-name = string
      odi_rmn_alb_listener_arn = string
      security_group_ids = list(string)
      subnet_ids = list(string)
    })
  
}