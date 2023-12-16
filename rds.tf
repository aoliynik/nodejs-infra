# Allow access from VPC and caller IP
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "database-sg"
  description = "MySQL security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
}

# Password for master user
resource "random_password" "dbadmin" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create database instance
module "db" {
  depends_on = [ module.vpc ]

  source  = "terraform-aws-modules/rds/aws"
  version = "6.3.0"

  identifier = "database-instance"

  engine               = "mysql"
  engine_version       = "8.0"
  family               = "mysql8.0" # DB parameter group
  major_engine_version = "8.0"      # DB option group
  instance_class       = "db.t3.micro"

  allocated_storage     = 5
  max_allocated_storage = 10

  username               = "dbadmin"
  password               = random_password.dbadmin.result
  manage_master_user_password = false

  port     = 3306

  multi_az               = true
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  publicly_accessible = false
  skip_final_snapshot = true
}
