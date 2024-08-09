resource "aws_memorydb_subnet_group" "redis_subnet_group" {
  name = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-redis-subnet-group"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_memorydb_cluster" "redis" {
  acl_name                 = "open-access"
  name                     = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-redis-cluster"
  engine_version           = var.redis_engine_version
  node_type                = var.redis_node
  num_shards               = var.redis_num_shards
  num_replicas_per_shard   = var.redis_num_replicas_per_shard
  security_group_ids       = [var.security_group_id]
  snapshot_retention_limit = var.redis_snapshot_retention_limit
  subnet_group_name        = aws_memorydb_subnet_group.redis_subnet_group.id
  tls_enabled              = "false"

  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-redis-subnet-group"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}