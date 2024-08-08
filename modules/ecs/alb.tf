# resource "aws_lb" "odin_load_balancer" {
#   name               = var.load_balancer
#   #internal           = false
#   internal            = true
#   load_balancer_type = "application"
#   subnets = ["subnet-0a4ce226214c9a187", "subnet-0642c1d7246c4ed32", "subnet-0dce4373e1f4e4c87"]
#   #subnets            = ["subnet-0c33635f055e7b3ca", "subnet-0f3274cc561f7e4cb", "subnet-01812fcdbdae3c5ba"]
#   security_groups = [aws_security_group.odin_ecs_cluster_sg.id]
# }

# resource "aws_lb_target_group" "odin_target_group" {
#   name     = var.targate_group
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id
#   target_type = "ip"

#   health_check {
#     path = "/"
#   }
# }

# resource "aws_lb_listener" "odin_listener" {
#   load_balancer_arn = aws_lb.odin_load_balancer.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.odin_target_group.arn
#   }
# }
# # resource "aws_lb_listener" "odin_listener_cert" {
# #   load_balancer_arn = aws_lb.odin_load_balancer.arn
# #   port              = "443"
# #   protocol          = "HTTPS"
# #   ssl_policy        = "ELBSecurityPolicy-2016-08"
# #   certificate_arn   = var.certificate_arn

# #   default_action {
# #     type             = "forward"
# #     target_group_arn = aws_lb_target_group.odin_target_group.arn
# #   }
# # }