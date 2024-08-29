resource "random_password" "mongo_dwv_core_root_password" {
  length  = 64
  special = false
  depends_on = [ aws_instance.ec2s["mongo-0"] ]
}
resource "random_password" "mongo_dwv_core_app_password" {
  length  = 64
  special = false
  depends_on = [ aws_instance.ec2s["mongo-0"] ]
}
resource "random_password" "mongo_dwv_core_viewer_password" {
  length  = 64
  special = false
  depends_on = [ aws_instance.ec2s["mongo-0"] ]
}