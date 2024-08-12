variable "project_name" {}
variable "PROJECT_CUSTOMER" {}
variable "PROJECT_ENV" {}

variable "vpc" {
    type = object({
      create =  bool
      on_new = object({
        cidr = string
        azs = list(string)
        subnets = object({
          public = list(string)
          private = list(string)
        })
      })
    })
  
}
variable "msk" {
    type = object({
      create = bool
      volume_size = number
      number_of_broker_nodes = number
      instance_type = string
    })
  
}
variable "key_pair" {
    type = object({
      create = bool
    })
}
variable "ec2" {
    type = object({
      create = bool
      ami    = string
      instance_type = string
      associate_public_ip_address = string
      instance_profile = string 
    })
  
}

variable "secrets-manager" {
    type = object({
      create = bool
      secret_string = string
    })
  
}
variable "eks" {
    type = object({
      create = bool
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
variable "api-gateway" {
  type = object({
    create = bool
    certificate_arn = string
    integration_uri = string
    domain_name = string
    hosted_zone_id = string
  })
  
}
variable "ecr" {
    type = object({
      create = bool
    })
}



variable "rds" {
    type = object({
      create = bool
      db_name = string
      engine = string
      engine_version = string
      instance_class = string
      username = string
      password = string
      parameter_group_name = string
       rds = object({
        allocated_storage = number
        max_allocated_storage = number
        backup_retention_period = number
      })
    })
  
}
variable "s3" {
    type = object({
      create = bool
      names = list(string)
    })
  
}
variable "redis" {
    type = object({
      create = bool
      redis = object({
        engine_version = string
        node = string
        num_shards = number
        num_replicas_per_shard = number
        snapshot_retention_limit = number
      })
    })
  
}
