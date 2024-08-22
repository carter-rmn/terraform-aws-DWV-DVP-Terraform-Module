resource "aws_db_instance" "postgres" {
  count                     = var.rds.create ? 1 : 0
  identifier           =  "${local.dwv_prefix}-rds-cluster-core"
  engine               =  var.rds.engine
  engine_version       =  var.rds.engine_version
  instance_class       =  var.rds.instance_class
  allocated_storage    = var.rds.rds_allocated_storage 
  max_allocated_storage = var.rds.rds_max_allocated_storage
  storage_type          = "io2"
  iops                 = 1000
  db_name              =  var.rds.db_name
  username             =  var.rds.username
  password             =  var.rds.password
  parameter_group_name =  var.rds.parameter_group_name
  skip_final_snapshot  = false 
  performance_insights_enabled      = "true"
  apply_immediately                 = true
  publicly_accessible               = false
  enabled_cloudwatch_logs_exports   = ["postgresql"]
  backup_retention_period           = 7
  backup_window = "01:00-02:00"
  maintenance_window = "mon:02:30-mon:03:30"
  vpc_security_group_ids = [aws_security_group.sg_rds[0].id]
  db_subnet_group_name = aws_db_subnet_group.rds_postgress[0].id
  tags = {
    Name        = "${local.dwv_prefix}-rds-cluster-core"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }

}
resource "aws_db_subnet_group" "rds_postgress" {
  count                     = var.rds.create ? 1 : 0
  name        = "${local.dwv_prefix}-rds-subnet-group-core"
  description =  "core Postgress RDS private subnet group"
  subnet_ids  = var.vpc.subnets.private
}
