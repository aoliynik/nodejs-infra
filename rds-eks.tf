provider "kubernetes" {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
}

resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql"
  }
  spec {
    type = "ExternalName"
    external_name = module.db.db_instance_address
  }
}

resource "kubernetes_secret" "mysql-auth" {
  metadata {
    name = "mysql-auth"
  }

  data = {
    username = "dbadmin"
    password = random_password.dbadmin.result
  }
}