# resource "aws_ecs_task_definition" "odin_task_definition" {
#   family                   = var.task_definition
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "4096"
#   memory                   = "30720"
#   network_mode             = "awsvpc"

#   execution_role_arn = aws_iam_role.odin_task_execution_role.arn

#   container_definitions = <<DEFINITION
#   [
#     {
#       "name": "${var.container_name}",
#       "image": "${var.ecr_url}:latest",
#       "cpu": 4096,
#       "memory": 8192,
#       "portMappings": [
#         {
#           "containerPort": 9991,
#           "hostPort": 9991,
#           "protocol": "tcp"
#         }
#       ],
#       "logConfiguration": {
#         "logDriver": "awslogs",
#         "options": {
#           "awslogs-group": "/ecs/${var.container_name}-logs",
#           "awslogs-region": "us-east-1",
#           "awslogs-stream-prefix": "${var.container_name}"
#         }
#       },
#       "essential": true,
#       "environment": [
#         {
#           "name": "APPLICATION_NAME",
#           "value": "${var.APPLICATION_NAME}"
#         },
#         {
#           "name": "BEAT_CRON",
#           "value": "${var.BEAT_CRON}"
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
#           "name": "KAFKA_BOOTSTRAP_SERVERS",
#           "value": "${var.KAFKA_BOOTSTRAP_SERVERS}"
#         },
#         {
#           "name": "KAFKA_JOB_TOPIC",
#           "value": "${var.KAFKA_JOB_TOPIC}"
#         },
#         {
#           "name": "KAFKA_CONSUMER_GROUP_ID",
#           "value": "${var.KAFKA_CONSUMER_GROUP_ID}"
#         },
#         {
#           "name": "ODIN_STORAGE_DB_URL",
#           "value": "${var.ODIN_STORAGE_DB_URL}"
#         },
#         {
#           "name": "ODIN_STORAGE_DB_PASSWORD",
#           "value": "${var.ODIN_STORAGE_DB_PASSWORD}"
#         },
#         {
#           "name": "ODIN_STORAGE_DB_USERNAME",
#           "value": "${var.ODIN_STORAGE_DB_USERNAME}"
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

resource "aws_iam_role" "odin_task_execution_role" {
  name = "Odin_AmazonECSTaskExecutionRolePolicy"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "odin_task_execution_policy_attachment" {
  name       = "odin_AmazonECSTaskExecutionRolePolicy-attachment"
  roles      = [aws_iam_role.odin_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "my_log_group" {
  name = "/ecs/${var.container_name}-logs"
  retention_in_days = 7  # Set your desired retention period
}
resource "aws_iam_policy" "ecs_msk_policy" {
  name = "odin_ecs_msk_policy"
  policy = file("modules/ecs/ecs-msk-policy.json")
}
resource "aws_iam_policy_attachment" "odin_msk_execution_policy_attachment" {
  name       = "odin_MskExecutionRolePolicy-attachment"
  roles      = [aws_iam_role.odin_task_execution_role.name]
  policy_arn = aws_iam_policy.ecs_msk_policy.arn
}
