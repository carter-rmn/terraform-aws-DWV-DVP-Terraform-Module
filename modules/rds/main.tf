resource "aws_db_instance" "postgres" {
  identifier           =  "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-rds-cluster-odin"
  engine               =  var.engine
  engine_version       =  var.engine_version
  instance_class       =  var.instance_class
  allocated_storage    = var.rds_allocated_storage 
  max_allocated_storage = var.rds_max_allocated_storage
  storage_type          = "io2"
  iops                 = 1000
  db_name              =  var.db_name
  username             =  var.username
  password             =  var.password
  parameter_group_name =  var.parameter_group_name
  skip_final_snapshot  = false 
  performance_insights_enabled      = "true"
  apply_immediately                 = true
  publicly_accessible               = false
  enabled_cloudwatch_logs_exports   = ["postgresql"]
  backup_retention_period           = 7
  backup_window = "01:00-02:00"
  maintenance_window = "mon:02:30-mon:03:30"
  vpc_security_group_ids = [var.security_group_ids]
  db_subnet_group_name = aws_db_subnet_group.rds_postgress.id
  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-rds-cluster-odin"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }

}
resource "aws_db_subnet_group" "rds_postgress" {
  name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-rds-subnet-group-odin"
  description =  "odin Postgress RDS private subnet group"
  subnet_ids  = var.subnet_ids
}
