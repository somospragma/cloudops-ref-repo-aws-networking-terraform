############################################################################
# Modulo VPC - Networking Base Pragma
############################################################################
module "vpc" {
  source = "git::https://github.com/somospragma/cloudops-ref-repo-aws-vpc-terraform.git?ref=v1.0.2"
  
  providers = {
    aws.project = aws.principal
  }

  # Variables obligatorias de nomenclatura
  client      = var.client
  project     = var.project
  environment = var.environment
  aws_region  = var.region
  
  # Configuración de la VPC
  cidr_block                 = var.cidr_block
  instance_tenancy           = var.instance_tenancy
  enable_dns_support         = var.enable_dns_support
  enable_dns_hostnames       = var.enable_dns_hostnames
  flow_log_retention_in_days = var.flow_log_retention_in_days

  # Configuración de subredes
  subnet_config = var.subnet_config
  
  # Configuración de gateways
  create_igw = var.create_igw
  create_nat = var.create_nat
  
  # Configuración de NAT Gateway
  nat_mode          = var.nat_mode
  nat_regional_mode = var.nat_regional_mode
  
  # Tags adicionales (incluye tags de EKS)
  additional_tags = var.additional_tags
}

############################################################################
# Security Groups - Usando módulo de referencia
############################################################################
module "security_groups" {
  source = "git::https://github.com/somospragma/cloudops-ref-repo-aws-sg-terraform.git?ref=v1.0.0"
  
  providers = {
    aws.project = aws.principal
  }

  # Variables obligatorias de nomenclatura
  client      = var.client
  project     = var.project
  environment = var.environment

  # ✅ Consumir local transformado (PC-IAC-026)
  # Los VPC IDs ya fueron inyectados en locals.tf
  sg_config = local.sg_config_transformed

  depends_on = [module.vpc]
}

############################################################################
# Modulo VPC Endpoints - Base Pragma
############################################################################
module "vpc_endpoints" {
  source = "git::https://github.com/somospragma/cloudops-ref-repo-aws-vpc-endpoint-terraform.git?ref=v1.0.0"
  
  providers = {
    aws.project = aws.principal
  }

  # Variables obligatorias de nomenclatura
  client      = var.client
  project     = var.project
  environment = var.environment

  # ✅ Consumir local transformado (PC-IAC-026)
  # Los IDs dinámicos ya fueron inyectados en locals.tf
  vpc_endpoints = local.vpc_endpoints_transformed

  depends_on = [module.vpc, module.security_groups]
}
