locals {
  dwv_project_name = "${var.PROJECT_PRENAME}{var.PROJECT_NAME}"
  #dwv_project_name = "${var.PROJECT_PRENAME}dwv"
  dwv_prefix       = "${local.dwv_project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}"

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
  mongo = {
      port = 27017
      dwv_core = {
        name = "dwvcoreDB"
        usernames = {
          root   = "root"
          admin  = "admin"
          app    = "dwv_core"
          viewer = "viewer"
        }
      }
    }  
}
