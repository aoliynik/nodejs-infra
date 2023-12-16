module "eks-kubeconfig" {
  source     = "hyperbadger/eks-kubeconfig/aws"
  version    = "2.0.0"
  depends_on = [ module.eks ]

  cluster_name = module.eks.cluster_name
}

resource "local_sensitive_file" "kubeconfig" {
  content              = module.eks-kubeconfig.kubeconfig
  filename             = "kubeconfig_${var.cluster_name}"
  file_permission      = "600"
  directory_permission = "700"
}
