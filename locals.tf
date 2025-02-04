locals {
  dwv_project_name = "${var.PROJECT_PRENAME}${var.PROJECT_NAME}"
  #dwv_project_name = "${var.PROJECT_PRENAME}dwv"
  dwv_prefix   = "${local.dwv_project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}"
  alarm_config = jsondecode(data.local_file.alarm_config.content)

  keys = { for item in distinct([for item, _ in local.ec2.instances : element(split("-", item), 0)]) : item => {} }

  msk = { bootstrap_brokers = var.msk.create ? aws_msk_cluster.kafka_cluster[0].bootstrap_brokers : var.msk.existing.bootstrap_brokers }

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
        subnet_index  = ""
        volume_size   = ""
        public        = ""
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
  alarm = {
    ec2 = flatten([
      for ec2_instance, _ in var.ec2.instances : [
        for alarm in local.alarm_config.ec2 : {
          name     = "ec2-${ec2_instance}-${alarm.alarm_name}"
          ec2_name = ec2_instance
          alarm    = alarm
        }
      ]
      if var.alarm.enabled
    ])
  }
}
