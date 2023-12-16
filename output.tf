output "db_host" {
  value = module.db.db_instance_address
}

output "db_port" {
  value = module.db.db_instance_port
}
