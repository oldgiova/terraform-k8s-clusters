include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//mender.io.secrets"
}

dependency "k8s_cluster" {
  config_path = "../kind"
  mock_outputs = {
    endpoint               = "dummy"
    client_certificate     = "dummy"
    client_key             = "dummy"
    cluster_ca_certificate = "dummy"
  }
}

dependency "mongodb" {
  config_path = "../mongodb"
  mock_outputs = {
    mongodb_root_password = "dummy"
  }
}

dependency "minio" {
  config_path = "../minio"
  mock_outputs = {
    minio_access_key = "dummy"
    minio_secret_key = "dummy"
  }
}

inputs = {
  kubernetes_host                   = "https://127.0.0.1:6443"
  kubernetes_client_certificate     = dependency.k8s_cluster.outputs.client_certificate
  kubernetes_client_key             = dependency.k8s_cluster.outputs.client_key
  kubernetes_cluster_ca_certificate = dependency.k8s_cluster.outputs.cluster_ca_certificate

  mender_wildcard_cert             = run_cmd("--terragrunt-quiet", "./.scripts/pass_secret_certificate.sh", "mender/saas/k8s/secret-ca-certificate.yaml", "cert.crt")
  mender_wildcard_privatekey       = run_cmd("--terragrunt-quiet", "./.scripts/pass_secret_certificate.sh", "mender/saas/k8s/secret-ca-certificate.yaml", "private.key")
  mender_docker_hub_secret         = run_cmd("--terragrunt-quiet", "./.scripts/pass_secret_certificate.sh", "mender/saas/k8s/secret-docker-hub-secret.yaml", ".dockerconfigjson")
  mender_registry_mender_io_secret = run_cmd("--terragrunt-quiet", "./.scripts/pass_secret_certificate.sh", "mender/saas/k8s/secret-registry-mender-io-secret.yaml", ".dockerconfigjson")
  mender_mongodb_connection_string = "mongodb://root:${dependency.mongodb.outputs.mongodb_root_password}@mongodb-0.mongodb-headless:27017,mongodb-1.mongodb-headless:27017"

  mender_aws_uri         = "https://mender-api-gateway"
  mender_aws_auth_key    = dependency.minio.outputs.minio_access_key
  mender_aws_auth_secret = dependency.minio.outputs.minio_secret_key

  mender_presign_hmac_secret = "fakedummysecret-substitutemewithrun_cmd_pass_inProd"
}

