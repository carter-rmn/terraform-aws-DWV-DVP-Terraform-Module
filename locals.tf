locals {
  dwv_project_name = "${var.PROJECT_PRENAME}${var.PROJECT_NAME}"
  #dwv_project_name = "${var.PROJECT_PRENAME}dwv"
  dwv_prefix   = "${local.dwv_project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}"
  alarm_config = jsondecode(data.local_file.alarm_config.content)

  s3s = {
    core-output-csv = { publicly_readable = false, users = ["app"] }
    log = { publicly_readable = false, users = [] }
  }

  ecr = var.ecr

  msk = { bootstrap_brokers = var.msk.create ? aws_msk_cluster.kafka_cluster[0].bootstrap_brokers : var.msk.existing.bootstrap_brokers }
  mongo_enabled = contains(keys(var.ec2.instances), "mongo-0")

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

  app_roles_eks = {
    for user, config in var.pod_identity.users : user => config
    if var.pod_identity.enabled
  }

  app_roles_s3 = flatten([
    for name, config in var.pod_identity.s3s : [
      for user in config.users : {
        name   = name
        user   = user
        config = config
      }
      if contains(keys(local.app_roles_eks), user)
    ]
  ])
}
