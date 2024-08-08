resource "aws_db_instance" "postgres" {
  allocated_storage    = var.rds_allocated_storage 
  max_allocated_storage = var.rds_max_allocated_storage
  storage_type          = "io2"
  iops                 = 1000
  db_name              =  var.db_name
  engine               =  var.engine
  engine_version       =  var.engine_version
  identifier           =  var.identifier
  instance_class       =  var.instance_class
  username             =  var.username
  password             =  var.password
  parameter_group_name =  var.parameter_group_name
  skip_final_snapshot  = false 
  performance_insights_enabled      = "true"
  apply_immediately                 = true
  publicly_accessible               = false
  enabled_cloudwatch_logs_exports   = ["postgresql"]
  backup_retention_period           = var.rds_backup_retention_period
  backup_window = "01:00-02:00"
  maintenance_window = "mon:02:30-mon:03:30"
  vpc_security_group_ids = [var.ecs_sg]
  db_subnet_group_name = aws_db_subnet_group.rds_postgress.id

}
resource "aws_db_subnet_group" "rds_postgress" {
  name        = var.db_subnet_group
  description =  "odin Postgress RDS private subnet group"
  subnet_ids  = var.subnet_ids
}
