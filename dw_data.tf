data "local_file" "alarm_config" {
  filename = "${path.module}/config/alarms.json"
}
