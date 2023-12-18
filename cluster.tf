module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.20.0"

  cluster_name                   = var.cluster_name
  cluster_version                = "1.26"
  subnet_ids                     = module.vpc.private_subnets
  vpc_id                         = module.vpc.vpc_id
  enable_irsa                    = false
  create_kms_key                 = false
  cluster_encryption_config      = {}
  cluster_enabled_log_types      = []
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    main = {
      desired_capacity = 3
      max_capacity     = 4
      min_capacity     = 3
      instance_type    = var.instance_type
      capacity_type    = "ON_DEMAND"
    }
  }
}
