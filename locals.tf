locals {
  dev-odin-infra = jsondecode(
    data.aws_secretsmanager_secret_version.creds_odin.secret_string
  )
  dev-data-weaver-infra = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
  keys = { for item in distinct([for item, _ in local.ec2.instances : element(split("-", item), 0)]) : item => {} }

  ecr = {
    repositories = [
      "management",
      "frontend",
      "odin-executor",
      "odin-scheduler",
      "odin-web"
    ]
  }
  ec2 = {
      ami = "ami-0083d3f8b2a6c7a81"
      instances = {
        mongo-1 = {
          instance_type = "t2.micro"
          subnet_index = 0
          volume_size = 32
          public = true
        }
      }
  }

  
}