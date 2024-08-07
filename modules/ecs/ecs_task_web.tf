# resource "aws_ecs_task_definition" "odin_task_definition_web_1" {
#   family                   = var.task_definition_web
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "2048"
#   memory                   = "4096"
#   network_mode             = "awsvpc"

#   execution_role_arn = aws_iam_role.odin_task_execution_role.arn

#   container_definitions = <<DEFINITION
#   [
#     {
#       "name": "${var.container_name_web}",
#       "image": "${var.ecr_web_url}:latest",
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
#           "awslogs-group": "/ecs/${var.container_name_web}-logs",
#           "awslogs-region": "us-east-1",
#           "awslogs-stream-prefix": "${var.container_name_web}"
#         }
#       },
#       "essential": true,
#       "environment": [
#         {
#           "name": "APPLICATION_NAME",
#           "value": "${var.APPLICATION_NAME_WEB}"
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
#           "name": "SERVER_PORT",
#           "value": "${var.SERVER_PORT}"
#         },
#         {
#           "name": "SEGMENT_DB_URL",
#           "value": "${var.SEGMENT_DB_URL}"
#         },
#         {
#           "name": "SEGMENT_DB_USERNAME",
#           "value": "${var.SEGMENT_DB_USERNAME}"
#         },
#         {
#           "name": "SEGMENT_DB_PASSWORD",
#           "value": "${var.SEGMENT_DB_PASSWORD}"
#         },
#         {
#           "name": "MONGODB_DATAWEAVER_URI",
#           "value": "${var.MONGODB_DATAWEAVER_URI}"
#         },{
#           "name": "MONGODB_DATAWEAVER_DATABASE",
#           "value": "${var.MONGODB_DATAWEAVER_DATABASE}"
#         },
#         {
#           "name": "KAFKA_BOOTSTRAP_SERVERS",
#           "value": "${var.KAFKA_BOOTSTRAP_SERVERS}"
#         },
#         {
#           "name": "KAFKA_CONSUMER_GROUP_ID",
#           "value": "${var.KAFKA_CONSUMER_GROUP_ID}"
#         },
#         {
#           "name": "ENCRYPTION_ALGORITHM",
#           "value": "${var.ENCRYPTION_ALGORITHM}"
#         },
#         {
#           "name": "ENCRYPTION_KEY",
#           "value": "${var.ENCRYPTION_KEY}"
#         },
#         {
#           "name": "KILL_FLOWS_TOPIC",
#           "value": "${var.KILL_FLOWS_TOPIC}"
#         },
#         {
#           "name": "S3_SEGMENT_CSV_BUCKET",
#           "value": "${var.S3_SEGMENT_CSV_BUCKET}"
#         },
#         {
#           "name": "AWS_ACCESS_KEY",
#           "value": "${var.AWS_ACCESS_KEY}"
#         },
#         {
#           "name": "AWS_SECRET_KEY",
#           "value": "${var.AWS_SECRET_KEY}"
#         },
#         {
#           "name": "AWS_REGION",
#           "value": "${var.AWS_REGION}"
#         }
#       ]
#     }
#   ]
#   DEFINITION
# }
# resource "aws_cloudwatch_log_group" "log_group" {
#   name = "/ecs/${var.container_name_web}-logs"
#   retention_in_days = 7  # Set your desired retention period
# }