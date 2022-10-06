variable "s3_bucket_name" {
  type = string
  descriptiokn = "S3 Bucket name"
}

variable "s3_versioning" {
  type = bool
  description = "Versioning enabled"
  default = true
}
