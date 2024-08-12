locals {
  keys = { for item in distinct([for item, _ in local.ec2.instances : element(split("-", item), 0)]) : item => {} }

  ecr = {
    repositories = [
      "",
    ]
  }
  ec2 = {
      ami = ""
      instances = {
        mongo-1 = {
          instance_type = ""
          subnet_index = ""
          volume_size = ""
          public = ""
        }
      }
  }

  
}