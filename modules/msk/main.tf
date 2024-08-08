resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = var.kafka_cluster
  kafka_version          = "3.6.0"
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type = var.kafka_instance_type
    client_subnets = var.subnet_ids
    storage_info {
      ebs_storage_info {
        volume_size = var.kafka_volume_size
      }
    }
    security_groups = [var.security_group]
  }
  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.kafka.name
      }
    }
  }
  configuration_info {
    arn = aws_msk_configuration.kafka_config.arn
    revision = aws_msk_configuration.kafka_config.latest_revision
  }
  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
    }
  }
  tags = {
    Name        = var.kafka_cluster
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_cloudwatch_log_group" "kafka" {
  name = var.kafka_cloudwatch_log_group
  retention_in_days = 3
  tags = {
    Name        = var.kafka_cluster
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
  
}

resource "aws_msk_configuration" "kafka_config" {
  kafka_versions = ["3.6.0"]
  name           = var.kafka_config

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