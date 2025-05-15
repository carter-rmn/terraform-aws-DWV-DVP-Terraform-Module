resource "aws_security_group" "sg_mongo" {
  count       = (contains(keys(var.ec2.instances), "mongo-0") & var.CREATE_NON_IAM) ? 1 : 0
  name        = "${local.dwv_prefix}-sg-mongo"
  description = "Allow Mongo Connection"
  depends_on = [ aws_instance.ec2s["mongo-0"] ]

  vpc_id = var.vpc.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = var.vpc.cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.dwv_prefix}-sg-mongo"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_security_group" "sg_ssh" {
  count       = (length(var.ec2.instances) > 0 & var.CREATE_NON_IAM) ? 1 : 0
  name        = "${local.dwv_prefix}-sg-ssh"

  vpc_id = var.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22 
    protocol    = "tcp"
    cidr_blocks = var.vpc.cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
    Name        = "${local.dwv_prefix}-sg-ssh"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
resource "aws_security_group" "sg_msk" {
  count       = (var.msk.create && var.CREATE_NON_IAM) ? 1 : 0
  name        = "${local.dwv_prefix}-sg-allow-msk"

  vpc_id = var.vpc.vpc_id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = var.vpc.cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.dwv_prefix}-sg-allow-msk"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
resource "aws_security_group" "sg_eks" {
  count       = (var.eks.create && var.CREATE_NON_IAM) ? 1 : 0
  name        = "${local.dwv_prefix}-sg-eks"

  vpc_id = var.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.vpc.cidr
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc.cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.dwv_prefix}-sg-eks"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
resource "aws_security_group" "sg_rds" {
  count       = (var.rds.create && var.CREATE_NON_IAM) ? 1 : 0
  name        = "${local.dwv_prefix}-sg-allow-rds"

  vpc_id = var.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.vpc.cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.dwv_prefix}-sg-allow-rds"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
resource "aws_security_group" "sg_redis" {
  count       = (var.redis.create && var.CREATE_NON_IAM) ? 1 : 0
  name        = "${local.dwv_prefix}-sg-allow-redis"

  vpc_id = var.vpc.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.vpc.cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.dwv_prefix}-sg-allow-redis"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
resource "aws_security_group" "sg_api_gateway" {
  count       = (var.api-gateway.create && var.CREATE_NON_IAM) ? 1 : 0
  name        = "${local.dwv_prefix}-sg-api-gateway"

  vpc_id = var.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.vpc.cidr
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc.cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.dwv_prefix}-sg-api-gateway"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
