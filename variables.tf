######################################################################
# Variables Globales
######################################################################
variable "region" {
  type        = string
  description = "Region AWS"
}

variable "profile" {
  type        = string
  description = "Profile cuenta AWS"
}

variable "client" {
  type        = string
  description = "Nombre del cliente"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.client))
    error_message = "El nombre del cliente debe contener solo letras minúsculas, números y guiones."
  }
}

variable "environment" {
  type        = string
  description = "Entorno de despliegue (dev, qa, pdn)"
  validation {
    condition     = contains(["dev", "qa", "pdn"], var.environment)
    error_message = "El entorno debe ser uno de: dev, qa, pdn."
  }
}

variable "project" {
  description = "Nombre del proyecto"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "El nombre del proyecto debe contener solo letras minúsculas, números y guiones."
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to be applied to the resources"
}

######################################################################
# Variables VPC
######################################################################
variable "cidr_block" {
  type        = string
  description = "El bloque CIDR para la VPC"
  
  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "Must be valid CIDR."
  }
}

variable "instance_tenancy" {
  type        = string
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
  validation {
    condition     = can(regex("^(default|dedicated)$", var.instance_tenancy))
    error_message = "Invalid tenancy, must be default or dedicated"
  }
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "A boolean flag to enable/disable DNS support in the VPC"
  default     = true
}

variable "flow_log_retention_in_days" {
  type        = number
  description = "Días de retención de los flow logs de VPC"
  default     = 7
}

variable "create_igw" {
  type        = bool
  description = "Crear Internet Gateway"
  default     = true
}

variable "create_nat" {
  type        = bool
  description = "Crear NAT Gateway"
  default     = true
}

variable "subnet_config" {
  description = "Configuración de subnets"
  type = map(object({
    custom_routes = list(object({
      destination_cidr_block    = string
      carrier_gateway_id        = optional(string)
      core_network_arn          = optional(string)
      egress_only_gateway_id    = optional(string)
      nat_gateway_id            = optional(string)
      local_gateway_id          = optional(string)
      network_interface_id      = optional(string)
      transit_gateway_id        = optional(string)
      vpc_endpoint_id           = optional(string)
      vpc_peering_connection_id = optional(string)
    }))
    public      = bool
    include_nat = optional(bool, false)
    subnets = list(object({
      cidr_block        = string
      availability_zone = string
    }))
  }))
}

######################################################################
# Variables NAT Gateway
######################################################################
variable "nat_mode" {
  type        = string
  description = "Modo de NAT Gateway: 'zonal' (uno por AZ) o 'regional' (único para toda la VPC)"
  default     = "regional"
  validation {
    condition     = can(regex("^(zonal|regional)$", var.nat_mode))
    error_message = "nat_mode debe ser 'zonal' o 'regional'"
  }
}

variable "nat_regional_mode" {
  type        = string
  description = "Modo de gestión de IPs para NAT Gateway Regional: 'auto' (AWS gestiona) o 'manual' (especificar EIPs)"
  default     = "auto"
  validation {
    condition     = can(regex("^(auto|manual)$", var.nat_regional_mode))
    error_message = "nat_regional_mode debe ser 'auto' o 'manual'"
  }
}

######################################################################
# Variables Additional Tags
######################################################################
variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionales para aplicar a todos los recursos (incluye tags de EKS)"
  default     = {}
}

######################################################################
# Variables Security Groups
######################################################################
variable "sg_config" {
  description = "Configuración de Security Groups"
  type = map(object({
    description     = string
    vpc_id          = string
    service         = string
    application     = string
    additional_tags = optional(map(string), {})
    ingress = list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      security_groups = list(string)
      prefix_list_ids = list(string)
      self            = bool
      description     = string
    }))
    egress = list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      prefix_list_ids = list(string)
      security_groups = list(string)
      self            = bool
      description     = string
    }))
  }))
  default = {}
}

######################################################################
# Variables VPC Endpoints
######################################################################
variable "vpc_endpoints" {
  type = map(object({
    vpc_id              = string
    service_name        = string
    vpc_endpoint_type   = string
    private_dns_enabled = optional(bool, false)
    security_group_ids  = optional(list(string), [])
    subnet_ids          = optional(list(string), [])
    route_table_ids     = optional(list(string), [])
  }))
  description = <<-EOF
    Map of VPC Endpoints to create. Key is the endpoint identifier.
    Leave IDs empty ("", []) to use automatic injection from modules.
  EOF
  default = {}
}
