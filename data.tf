data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "dev-data-weaver-infra"
}
data "aws_secretsmanager_secret_version" "creds_odin" {
  secret_id = "dev-odin-infra"
}