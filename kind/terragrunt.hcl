//include {
//  path = find_in_parent_folder()
//}

terraform {
  source = "../modules//kind/."
}

inputs = {
  cluster_name = "mykindcluster"
  node_image   = "kindest/node:v1.22.4"
}

