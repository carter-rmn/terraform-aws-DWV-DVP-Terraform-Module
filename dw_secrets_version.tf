resource "aws_secretsmanager_secret_version" "secret_ec2s" {
  for_each = var.secrets-version.keys
  secret_id     = aws_secretsmanager_secret.secret_ec2s[each.key].id
  secret_string = tls_private_key.ec2s[each.key].private_key_pem
}

resource "aws_secretsmanager_secret_version" "dwv_secret_terraform" {
  count   = var.secrets-version.create ? 1 : 0
  secret_id = aws_secretsmanager_secret.dwv_secret_terraform.id
  secret_string = jsonencode({
    mongo = {
      dw_core = {
        name        = local.mongo.dw_core.name
        port        = local.mongo.port
        private_ip  = aws_instance.ec2s["mongo-0"].private_ip
        private_dns = aws_instance.ec2s["mongo-0"].private_dns
        public_dns  = aws_instance.ec2s["mongo-0"].public_dns
        public_ip   = aws_instance.ec2s["mongo-0"].public_ip
        users = {
          root = {
            username = local.mongo.dw_core.usernames.root
            password = random_password.mongo_dw_core_root_password.result
          }
          app = {
            username          = local.mongo.dw_core.usernames.app
            password          = random_password.mongo_dw_core_app_password.result
            connection_string = "mongodb://${local.mongo.dw_core.usernames.app}:${random_password.mongo_dw_core_app_password.result}@${join(",", [for item in aws_instance.ec2s : "${item.private_ip}:${local.mongo.port}" if length(regexall("(mongo-\\d+)", item.tags.Short)) > 0])}/${local.mongo.dw_core.name}?authSource=admin${length([for item in aws_instance.ec2s : 1 if length(regexall("(mongo-\\d+)", item.tags.Short)) > 0]) > 1 ? "&replicaSet=dwv" : ""}"
          }
          viewer = {
            username          = local.mongo.dw_core.usernames.viewer
            password          = random_password.mongo_dw_core_viewer_password.result
            connection_string = "mongodb://${local.mongo.dw_core.usernames.viewer}:${random_password.mongo_dw_core_viewer_password.result}@${join(",", [for item in aws_instance.ec2s : "${item.private_ip}:${local.mongo.port}" if length(regexall("(mongo-\\d+)", item.tags.Short)) > 0])}/${local.mongo.dw_core.name}?authSource=admin${length([for item in aws_instance.ec2s : 1 if length(regexall("(mongo-\\d+)", item.tags.Short)) > 0]) > 1 ? "&replicaSet=dwv" : ""}"
          }
        }
      }
    },
    msk = {
      address = substr(element(split(":", element(split(",", aws_msk_cluster.kafka_cluster.bootstrap_brokers), 0)), 0), 4, -1)
      port    = element(split(":", element(split(",", aws_msk_cluster.kafka_cluster.bootstrap_brokers), 0)), 1)
      url     = substr(element(split(",", aws_msk_cluster.kafka_cluster.bootstrap_brokers), 0), 4, -1)
    }
    })
}
