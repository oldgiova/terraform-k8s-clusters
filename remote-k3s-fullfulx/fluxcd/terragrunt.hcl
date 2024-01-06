include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//fluxcd-crd"
}

inputs = {
  fluxcd = {
    enabled      = true
    helm_version = "2.12.2"
  }
}

