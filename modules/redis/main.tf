resource "aws_memorydb_subnet_group" "redis_subnet_group" {
  name       = var.redis_sg
  subnet_ids = var.subnet_ids

  tags = {
    Name        = var.redis_sg
  }
}

resource "aws_memorydb_cluster" "redis" {
  acl_name                 = "open-access"
  name                     = var.redis_name
  engine_version           = var.redis_engine_version
  node_type                = var.redis_node
  num_shards               = var.redis_num_shards
  num_replicas_per_shard   = var.redis_num_replicas_per_shard
  security_group_ids       = [var.eks_sg]
  snapshot_retention_limit = var.redis_snapshot_retention_limit
  subnet_group_name        = aws_memorydb_subnet_group.redis_subnet_group.id
  tls_enabled              = "false"

  tags = {
    Name        = var.redis_name
  }
}