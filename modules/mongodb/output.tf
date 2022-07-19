output "mongodb_root_password" {
  value     = random_password.rootpassword.result
  sensitive = true
}

output "mongodb_replicaset_key" {
  value     = random_password.replicasetkey.result
  sensitive = true
}
