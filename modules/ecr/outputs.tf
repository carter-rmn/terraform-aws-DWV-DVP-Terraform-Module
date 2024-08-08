output "ecr_url" {
  value = aws_ecr_repository.ecr_odin.repository_url
}
output "ecr_web_url" {
  value = aws_ecr_repository.ecr_web.repository_url
}
output "ecr_scheduler_url" {
  value = aws_ecr_repository.ecr_scheduler.repository_url
}