# resource "aws_ecs_task_definition" "odin_task_definition_scheduler" {
#   family                   = var.task_definition_scheduler
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "2048"
#   memory                   = "4096"
#   network_mode             = "awsvpc"

#   execution_role_arn = aws_iam_role.odin_task_execution_role.arn

#   container_definitions = <<DEFINITION
#   [
#     {
#       "name": "${var.container_name_scheduler}",
#       "image": "${var.ecr_scheduler_url}:latest",
#       "cpu": 2048,
#       "memory": 4096,
#       "portMappings": [
#         {
#           "containerPort": 80,
#           "hostPort": 80,
#           "protocol": "tcp"
#         }
#       ],
#       "logConfiguration": {
#         "logDriver": "awslogs",
#         "options": {
#           "awslogs-group": "/ecs/${var.container_name_scheduler}-logs",
#           "awslogs-region": "us-east-1",
#           "awslogs-stream-prefix": "${var.container_name_scheduler}"
#         }
#       },
#       "essential": true,
#       "environment": [
#         {
#           "name": "APPLICATION_NAME",
#           "value": "${var.APPLICATION_NAME_SCHEDULER}"
#         },
#         {
#           "name": "BEAT_CRON",
#           "value": "${var.BEAT_CRON_SCHEDULER}"
#         },
#         {
#           "name": "MONGODB_URI",
#           "value": "${var.MONGODB_URI}"
#         },
#         {
#           "name": "MONGODB_HOST",
#           "value": "${var.MONGODB_HOST}"
#         },
#         {
#           "name": "MONGODB_PORT",
#           "value": "${var.MONGODB_PORT}"
#         },
#         {
#           "name": "MONGODB_DATABASE",
#           "value": "${var.MONGODB_DATABASE}"
#         },
#         {
#           "name": "KAFKA_JOB_TOPIC",
#           "value": "${var.KAFKA_JOB_TOPIC}"
#         },
#         {
#           "name": "BOOTSTRAP_SERVERS",
#           "value": "${var.KAFKA_BOOTSTRAP_SERVERS}"
#         },
        
#         {
#           "name": "KAFKA_CONSUMER_GROUP_ID",
#           "value": "${var.KAFKA_CONSUMER_GROUP_ID}"
#         }
#       ]
#     }
#   ]
#   DEFINITION
# }
# resource "aws_cloudwatch_log_group" "log_group_scheduler" {
#   name = "/ecs/${var.container_name_scheduler}-logs"
#   retention_in_days = 7  # Set your desired retention period
# }