variable "project_name" {}
variable "PROJECT_CUSTOMER" {}
variable "PROJECT_ENV" {}

# variable "vpc" {
#     type = object({
#       create =  bool
#       on_new = object({
#         cidr = string
#         azs = list(string)
#         subnets = object({
#           public = list(string)
#           private = list(string)
#         })
#       })
#     })
  
# }
variable "vpc" {
  type = object({
    create =  bool
    vpc_id = string
    cidr = string
    azs = list(string)
    subnets = object({
      public = list(string)
      private = list(string)
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
      #create = bool
      keys = set(string)
    })
}

variable "ec2" {
  type = object({
    #create = bool
    ami = string
    instances = map(object({
      instance_type = string
      subnet_index  = number
      volume_size   = number
      associate_public_ip_address = bool
      instance_profile = string
    }))
  })
}
variable "secrets-manager" {
    type = object({
      #create = bool
      keys = set(string)
    })  
}
variable "secrets-version" {
    type = object({
      #create = bool
      keys = list(string)
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
      #create = bool
      ecr = list(string)
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
      rds_allocated_storage = number
      rds_max_allocated_storage = number
    })  
}

variable "s3" {
    type = object({
      #create = bool
      names = list(string)
    })
}

variable "redis" {
    type = object({
      create = bool
      redis_engine_version = string
      redis_node = string
      redis_num_shards = number
      redis_num_replicas_per_shard = number
      redis_snapshot_retention_limit = number
    })
  
}