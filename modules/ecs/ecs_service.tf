# resource "aws_ecs_service" "odin_ecs_service" {
#   name            = var.ecs_service
#   cluster         = aws_ecs_cluster.odin_ecs_cluster.id
#   task_definition = aws_ecs_task_definition.odin_task_definition.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"
#   network_configuration {
#     subnets = ["subnet-0a4ce226214c9a187", "subnet-0642c1d7246c4ed32", "subnet-0dce4373e1f4e4c87"]
#     security_groups = [aws_security_group.odin_ecs_cluster_sg.id]
#     assign_public_ip = false
#   }
#   lifecycle {
#     ignore_changes = [
#       task_definition,
#     ]
#   }
# }
#   resource "aws_ecs_service" "odin_ecs_service_web" {
#   name            = var.odin_ecs_service_web
#   cluster         = aws_ecs_cluster.odin_ecs_cluster.id
#   task_definition = aws_ecs_task_definition.odin_task_definition_web_1.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"
#   network_configuration {
#     subnets = ["subnet-0a4ce226214c9a187", "subnet-0642c1d7246c4ed32", "subnet-0dce4373e1f4e4c87"]
#     security_groups = [aws_security_group.odin_ecs_cluster_sg.id]
#     assign_public_ip = false
#   }
  
#   load_balancer {
#     target_group_arn = aws_lb_target_group.odin_target_group.arn
#     container_name   = var.container_name_web
#     container_port   = 80
#   }
#   lifecycle {
#     ignore_changes = [
#       task_definition,
#     ]
#   }
#   }
#   resource "aws_ecs_service" "odin_ecs_service_scheduler" {
#   name            = var.odin_ecs_service_scheduler
#   cluster         = aws_ecs_cluster.odin_ecs_cluster.id
#   task_definition = aws_ecs_task_definition.odin_task_definition_scheduler.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"
#   network_configuration {
#     subnets = ["subnet-0a4ce226214c9a187", "subnet-0642c1d7246c4ed32", "subnet-0dce4373e1f4e4c87"]
#     security_groups = [aws_security_group.odin_ecs_cluster_sg.id]
#     assign_public_ip = false
#   }
#   lifecycle {
#     ignore_changes = [
#       task_definition,  # Ignore changes to the task definition ARN
#     ]
#   }
#   }