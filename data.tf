###########################################
# VPC data name
# Value comes from Transversal Module
###########################################

data "aws_vpc" "vpc" {
  provider = aws.pra_idp_dev
  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-vpc"]
  }
}

###########################################
# Public subnets data names
# Values come from Transversal Module
###########################################

data "aws_subnet" "database_subnet_1" {
  provider = aws.pra_idp_dev
  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-subnet-database-1"] 
  }
}

data "aws_subnet" "database_subnet_2" {
  provider = aws.pra_idp_dev
  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-subnet-database-2"] 
  }
}

###########################################
# Private subnets data names
# Values come from Transversal Module
###########################################

data "aws_subnet" "private_subnet_1" {
  provider = aws.pra_idp_dev
  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-subnet-private-1"] 
  }
}

data "aws_subnet" "private_subnet_2" {
  provider = aws.pra_idp_dev
  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-subnet-private-2"] 
  }
}

###########################################
# Data Account
###########################################

data "aws_caller_identity" "current" {
  provider = aws.pra_idp_dev
}