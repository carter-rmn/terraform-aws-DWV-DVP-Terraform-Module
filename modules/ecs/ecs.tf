# resource "aws_ecs_cluster" "odin_ecs_cluster" {
#   name = var.ecs_cluster
  
#   setting {
#     name  = "containerInsights"
#     value = "enabled"
#   }

# }


resource "aws_security_group" "odin_ecs_cluster_sg" {
  name        = var.ecs_sg
  description = "Security group for ECS cluster"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9092
    to_port = 9092
    protocol = "tcp"
    security_groups = ["sg-0f24d3d43661cb90a"]
  }
  ingress {
    from_port = 9092
    to_port = 9092
    protocol = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_groups = ["${var.eks_sg}"]
  }
  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  lifecycle {
    ignore_changes = [ ingress ]
  }

}