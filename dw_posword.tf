resource "random_password" "mongo_dwv_core_root_password" {
  count   = var.password.create ? 1 : 0
  length  = 64
  special = false
}
resource "random_password" "mongo_dwv_core_app_password" {
  count   = var.password.create ? 1 : 0
  length  = 64
  special = false
}
resource "random_password" "mongo_dwv_core_viewer_password" {
  count   = var.password.create ? 1 : 0
  length  = 64
  special = false
}