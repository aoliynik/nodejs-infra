data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.2.0"

  name                 = "eks-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.1.0/24"]
  private_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets     = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_igw           = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  # Public access to RDS instances
  create_database_subnet_group           = true
  #create_database_subnet_route_table     = false
  #create_database_internet_gateway_route = false

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}
