resource "aws_memorydb_subnet_group" "redis_subnet_group" {
  count                     = var.redis.create ? 1 : 0
  name = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-redis-subnet-group"
  subnet_ids = [
    var.vpc.subnets.private[0],
    var.vpc.subnets.private[1]
  ]


  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-redis-subnet-group"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_memorydb_cluster" "redis" {
  count                     = var.redis.create ? 1 : 0
  acl_name                 = "open-access"
  name                     = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-redis-cluster"
  engine_version           = var.redis.redis_engine_version
  node_type                = var.redis.redis_node
  num_shards               = var.redis.redis_num_shards
  num_replicas_per_shard   = var.redis.redis_num_replicas_per_shard
  security_group_ids       = [aws_security_group.sg_redis[0].id]
  snapshot_retention_limit = var.redis.redis_snapshot_retention_limit
  subnet_group_name        = aws_memorydb_subnet_group.redis_subnet_group[0].id
  tls_enabled              = "false"

  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-redis-subnet-group"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}