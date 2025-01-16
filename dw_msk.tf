resource "aws_msk_cluster" "kafka_cluster" {
  count                     = var.msk.create ? 1 : 0
  cluster_name           = "${local.dwv_prefix}-msk-cluster"
  kafka_version          = "3.6.0"
  number_of_broker_nodes = var.msk.new.number_of_broker_nodes

  broker_node_group_info {
    instance_type = var.msk.new.instance_type
    client_subnets = var.vpc.subnets.private

    storage_info {
      ebs_storage_info {
        volume_size = var.msk.new.volume_size
      }
    }
    security_groups = [aws_security_group.sg_msk[0].id]
  }
  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.kafka[0].name
      }
    }
  }
  configuration_info {
    arn = aws_msk_configuration.kafka_config[0].arn
    revision = aws_msk_configuration.kafka_config[0].latest_revision
  }
  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
    }
  }
  tags = {
    Name        = "${local.dwv_prefix}-msk-cluster"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_cloudwatch_log_group" "kafka" {
  count                     = var.msk.create ? 1 : 0
  name = "${local.dwv_prefix}-msk-log-group"
  retention_in_days = 3
  tags = {
    Name        = "${local.dwv_prefix}-msk-log-group"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
  
}

resource "aws_msk_configuration" "kafka_config" {
  count                     = var.msk.create ? 1 : 0
  kafka_versions = ["3.6.0"]
  name           = "${local.dwv_prefix}-msk-config"

  server_properties = <<PROPERTIES
auto.create.topics.enable = true
delete.topic.enable = true
default.replication.factor=3
min.insync.replicas=1
num.io.threads=8
num.network.threads=5
num.partitions=1
num.replica.fetchers=2
offsets.topic.replication.factor=1
replica.lag.time.max.ms=30000
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
socket.send.buffer.bytes=102400
unclean.leader.election.enable=false
zookeeper.session.timeout.ms=18000
PROPERTIES
}