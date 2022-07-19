output "minio_access_key" {
  value = random_string.minio_access_key.result
}

output "minio_secret_key" {
  value     = random_password.minio_secret_key.result
  sensitive = true
}
