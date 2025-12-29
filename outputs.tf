############################################################################
# Outputs del módulo VPC
############################################################################
output "vpc_id" {
  description = "El ID de la VPC creada"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "Mapa de IDs de subnets (key = tipo-index, value = subnet_id)"
  value       = module.vpc.subnet_ids
}

output "route_table_ids" {
  description = "Mapa de IDs de route tables por tipo de subnet"
  value       = module.vpc.route_table_ids
}

output "nat_gateway_id" {
  description = "ID del NAT Gateway (zonal o regional)"
  value       = module.vpc.nat_gateway_id
}

output "nat_gateway_mode" {
  description = "Modo del NAT Gateway (zonal o regional)"
  value       = module.vpc.nat_gateway_mode
}

output "regional_nat_gateway_route_table_id" {
  description = "Route table ID creada automáticamente por el NAT Gateway Regional (solo en modo regional)"
  value       = module.vpc.regional_nat_gateway_route_table_id
}

############################################################################
# Outputs del módulo Security Groups
############################################################################
output "security_group_ids" {
  description = "Mapa de IDs de Security Groups creados"
  value       = module.security_groups.sg_ids
}

output "security_group_info" {
  description = "Información completa de Security Groups (ID y nombre)"
  value       = module.security_groups.sg_info
}

output "vpce_security_group_id" {
  description = "ID del Security Group para VPC Endpoints (backward compatibility)"
  value       = module.security_groups.sg_ids["vpce"]
}

############################################################################
# Outputs del módulo VPC Endpoints
############################################################################
output "vpc_endpoint_ids" {
  description = "Mapa de IDs de VPC Endpoints creados"
  value       = module.vpc_endpoints.vpc_endpoint_ids
}

output "vpc_endpoint_arns" {
  description = "Mapa de ARNs de VPC Endpoints creados"
  value       = module.vpc_endpoints.vpc_endpoint_arns
}

output "vpc_endpoint_dns_entries" {
  description = "Mapa de DNS entries de VPC Endpoints (Interface endpoints)"
  value       = module.vpc_endpoints.vpc_endpoint_dns_entries
}

output "vpc_endpoint_info" {
  description = "Información completa de todos los VPC Endpoints"
  value       = module.vpc_endpoints.vpc_endpoint_info
}
