include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../modules//cert-manager-route53"
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

dependency "cert-manager-crd" {
  config_path  = "../cert-manager-crd"
  skip_outputs = true
}

inputs = {
  k8s = {
    endpoint           = "https://${include.root.inputs.kubernetes_host}:6443"
    ca_certificate     = dependency.k8s_cluster.outputs.cluster_ca_certificate
    client_key         = dependency.k8s_cluster.outputs.client_key_enc
    client_certificate = dependency.k8s_cluster.outputs.client_certificate_enc
  }

  issuer_email          = "roberto.giova+oldgiovaletsencrypt@gmail.com"
  aws_route53_user_name = "route53-remote-kind"
  issuer_name           = "oldgiova-certmanager-issuer"
  issued_secret_name    = "route53-remote-kind"
  aws_hosted_zone_id    = "Z08177262P259XEY5HYB7"
  region                = "eu-south-1"
  server                = "https://acme-v02.api.letsencrypt.org/directory"
}

