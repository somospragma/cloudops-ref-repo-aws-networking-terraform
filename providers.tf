######################################################################
# Provider AWS
######################################################################
provider "aws" {
  region  = var.aws_region
  profile = var.profile

  default_tags {
    tags = var.common_tags
  }
}

provider "aws" {
  alias   = "pra_idp_dev"
  region  = var.aws_region
  profile = var.profile

  default_tags {
    tags = var.common_tags
  }
}

provider "aws" {
  alias   = "pra_idp_dev_2"
  region  = "us-east-2"  # Cambia a la región necesaria
  profile = var.profile

  default_tags {
    tags = var.common_tags
  }
}


###########################################
#Version definition - Terraform - Providers
###########################################

terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.31.0"
    }
  }
    backend "s3" {
        bucket         = "pragma-fc-dev-s3-tf-state"
        key            = "pragma-fc-dev-persistency/terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "pragma-fc-dev-dyntbl-persistency-tflocks"
        profile        = "pra_idp_dev"
    }
}
