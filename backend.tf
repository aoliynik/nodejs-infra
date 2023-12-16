terraform {
  required_version = "~>1.5.3"

  backend "s3" {
     bucket = "oliynyk-tf-state"
     key    = "nodeapp-infra/terraform.tfstate"
     region = "eu-north-1"
 }
}
