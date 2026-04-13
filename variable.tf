variable "PROJECT_CUSTOMER" {}
variable "PROJECT_ENV" {}
variable "PROJECT_PRENAME" {}
variable "PROJECT_NAME" {}
variable "AWS_REGION" {}
variable "ENDPOINT_PAGERDUTY" {}
variable "WEBHOOK_SLACK" {}
variable "CREATE_IAM" {
  type = bool
}
variable "CREATE_NON_IAM" {
  type = bool
}

# IF ECR IS NOT PROVIDED, USE THE DEFAULT VALUES
variable "ecr" {
  type = map(string)
  default = {
    webserver       = "webserver"
    executor        = "executor"
    scheduler       = "scheduler"
    core            = "core"
    frontend       = "dashboard"
    admin-dashboard = "admin-dashboard"
  }
}

variable "vpc" {
  type = object({
    vpc_id = string
    cidr   = list(string)
    azs    = list(string)
    subnets = object({
      public   = list(string)
      private  = list(string)
      database = list(string)
    })
  })
}
variable "msk" {
  type = object({
    create = bool
    new = object({
      volume_size            = number
      number_of_broker_nodes = number
      instance_type          = string
      subnet_ids             = list(string)
    })
    existing = object({
      bootstrap_brokers = string
    })
  })
}

variable "key_pair" {
  type = object({
    keys = set(string)
  })
}

variable "ec2" {
  type = object({
    ami = string
    instances = map(object({
      instance_type    = string
      subnet_index     = number
      volume_size      = number
      public           = bool
      instance_profile = string
    }))
  })
}

variable "secrets-manager" {
  type = object({
    keys   = set(string)
    create = bool
  })
}

variable "secrets-version" {
  type = object({
    keys   = set(string)
    create = bool
  })
}

variable "eks" {
  type = object({
    create                  = bool
    private_id              = list(string)
    fargate_namespaces = list(string)
    aws_eks_cluster_version = string
    existing = object({
      name = string
    })
  })
}

variable "api-gateway" {
  type = object({
    create          = bool
    certificate_arn = string
    integration_uri = string
    domain_name     = string
    hosted_zone_id  = string
  })
}

variable "rds" {
  type = object({
    create                    = bool
    db_name                   = string
    engine                    = string
    engine_version            = string
    instance_class            = string
    username                  = string
    password                  = string
    parameter_group_name      = string
    rds_allocated_storage     = number
    rds_max_allocated_storage = number
  })
}

variable "s3" {
  type = object({
    names = list(string)
  })
}

variable "redis" {
  type = object({
    create                         = bool
    redis_engine_version           = string
    redis_node                     = string
    redis_num_shards               = number
    redis_num_replicas_per_shard   = number
    redis_snapshot_retention_limit = number
  })
}

variable "alarm" {
  type = object({
    enabled = bool
    emails  = list(string)
  })
}

variable "pod_identity" {
  type = object({
    enabled = bool

    users = map(map(object({
      actions  = list(string)
      effect   = string
      resource = any
    })))

    apps = map(object({
      role_key = string
    }))

    s3s = optional(map(object({
      users = list(string)
    })), {})
  })
}
