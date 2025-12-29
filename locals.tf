############################################################################
# Local Transformations
############################################################################

# PC-IAC-026: Patrón de Transformación en Root
# Flujo: terraform.tfvars → variables.tf → data.tf → locals.tf → main.tf

locals {
  # Prefijo de gobernanza
  governance_prefix = "${var.client}-${var.project}-${var.environment}"
  
  # Transformación de sg_config con inyección de VPC ID
  sg_config_transformed = {
    for key, config in var.sg_config :
    key => merge(config, {
      # Inyectar VPC ID desde módulo VPC
      vpc_id = length(config.vpc_id) > 0 ? config.vpc_id : module.vpc.vpc_id
    })
  }
  
  # Transformación de vpc_endpoints con inyección de IDs dinámicos
  vpc_endpoints_transformed = {
    for key, config in var.vpc_endpoints :
    key => merge(config, {
      # Inyectar VPC ID desde módulo VPC
      vpc_id = length(config.vpc_id) > 0 ? config.vpc_id : module.vpc.vpc_id
      
      # Inyectar Security Group IDs desde módulo SG
      security_group_ids = length(config.security_group_ids) > 0 ? config.security_group_ids : (
        config.vpc_endpoint_type == "Interface" ? [module.security_groups.sg_ids["vpce"]] : []
      )
      
      # Inyectar Subnet IDs desde módulo VPC (para Interface endpoints)
      subnet_ids = length(config.subnet_ids) > 0 ? config.subnet_ids : (
        contains(["Interface", "GatewayLoadBalancer"], config.vpc_endpoint_type) ? [
          module.vpc.subnet_ids["private-0"],
          module.vpc.subnet_ids["private-1"],
          module.vpc.subnet_ids["private-2"]
        ] : []
      )
      
      # Inyectar Route Table IDs desde módulo VPC (para Gateway endpoints)
      route_table_ids = length(config.route_table_ids) > 0 ? config.route_table_ids : (
        config.vpc_endpoint_type == "Gateway" ? [
          module.vpc.route_table_ids["private"],
          module.vpc.route_table_ids["service"],
          module.vpc.route_table_ids["database"]
        ] : []
      )
    })
  }
}
