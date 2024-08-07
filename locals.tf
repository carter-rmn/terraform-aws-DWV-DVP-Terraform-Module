locals {
  dev-odin-infra = jsondecode(
    data.aws_secretsmanager_secret_version.creds_odin.secret_string
  )
  dev-data-weaver-infra = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}