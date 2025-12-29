######################################################################
# Configuracion Providers AWS
######################################################################
provider "aws" {
  region  = var.region
  alias   = "principal"
  profile = var.profile
  
  default_tags {
    tags = var.common_tags
  }
}

######################################################################
# Configuracion Providers Terraform
######################################################################
terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.31.0"
    }
  }
  backend "s3" {
    bucket       = "linuxeros-terraform-lab"
    key          = "networking-referencia/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
    profile      = "pra_chaptercloudops_lab"
  }
}
