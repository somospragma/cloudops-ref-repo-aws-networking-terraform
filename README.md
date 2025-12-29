# Línea Base de Networking - Pragma

Infraestructura de red base para proyectos Pragma usando módulos de referencia certificados.

## 📋 Descripción

Esta línea base proporciona una configuración de red completa y lista para usar con:
- VPC con NAT Gateway Regional
- 4 tipos de subnets (public, private, service, database)
- Security Groups base
- VPC Endpoints esenciales

## 🏗️ Arquitectura

### VPC Configuration
- **CIDR Block**: 10.0.0.0/16
- **NAT Gateway**: Regional (nuevo modo de AWS)
- **Availability Zones**: 3 (us-east-1a, us-east-1b, us-east-1c)

### Subnets (4 tipos)

#### 1. Public Subnets
- **Uso**: Load Balancers, Bastion Hosts
- **CIDRs**: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24
- **Internet Gateway**: ✅ Sí

#### 2. Private Subnets
- **Uso**: Aplicaciones, Servicios
- **CIDRs**: 10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24
- **NAT Gateway**: ✅ Sí (Regional)

#### 3. Service Subnets
- **Uso**: Microservicios, APIs
- **CIDRs**: 10.0.21.0/24, 10.0.22.0/24, 10.0.23.0/24
- **NAT Gateway**: ✅ Sí (Regional)

#### 4. Database Subnets
- **Uso**: RDS, ElastiCache, Redshift
- **CIDRs**: 10.0.31.0/24, 10.0.32.0/24, 10.0.33.0/24
- **NAT Gateway**: ❌ No (aisladas)

## 🔌 VPC Endpoints Incluidos

### Gateway Endpoints (sin costo)
- ✅ **S3** - Almacenamiento, backups, logs
- ✅ **DynamoDB** - Base de datos NoSQL

### Interface Endpoints (con costo)
- ✅ **SSM** - Systems Manager (Parameter Store)
- ✅ **SSM Messages** - Session Manager
- ✅ **EC2 Messages** - Session Manager
- ✅ **Secrets Manager** - Gestión de secretos
- ✅ **CloudWatch Logs** - Centralización de logs

## 📦 Módulos Utilizados

| Módulo | Versión | Repositorio |
|--------|---------|-------------|
| VPC | v1.0.2 | [cloudops-ref-repo-aws-vpc-terraform](https://github.com/somospragma/cloudops-ref-repo-aws-vpc-terraform) |
| Security Groups | v1.0.0 | [cloudops-ref-repo-aws-sg-terraform](https://github.com/somospragma/cloudops-ref-repo-aws-sg-terraform) |
| VPC Endpoints | v1.0.0 | [cloudops-ref-repo-aws-vpc-endpoint-terraform](https://github.com/somospragma/cloudops-ref-repo-aws-vpc-endpoint-terraform) |

## 🔐 Permisos IAM Requeridos

**IMPORTANTE**: Antes de desplegar esta infraestructura, asegúrate de que tu usuario/rol de IAM tenga los permisos necesarios.

📋 **Ver permisos detallados**: [`iam-permissions/README.md`](./iam-permissions/README.md)

### Permisos Mínimos Requeridos:
- ✅ VPC y Subnets (Create, Delete, Modify, Describe)
- ✅ NAT Gateway e Internet Gateway
- ✅ Security Groups
- ✅ VPC Endpoints (Gateway e Interface)
- ✅ CloudWatch Logs (para Flow Logs)
- ✅ IAM (crear rol para Flow Logs)

### Aplicar Política Recomendada:
```bash
# Usar la política mínima incluida
aws iam create-policy \
  --policy-name PragmaNetworkingDeploymentPolicy \
  --policy-document file://iam-permissions/networking-deployment-policy.json

# Adjuntar a tu usuario
aws iam attach-user-policy \
  --user-name tu-usuario \
  --policy-arn arn:aws:iam::ACCOUNT-ID:policy/PragmaNetworkingDeploymentPolicy
```

## ⚙️ Pre-requisitos

### Herramientas Requeridas
- **Terraform** >= 1.0
- **AWS CLI** >= 2.0
- **Credenciales AWS** configuradas

### Verificar Configuración
```bash
# Verificar tu identidad
aws sts get-caller-identity

# Configurar perfil si es necesario
aws configure --profile tu-perfil-aws
```

## 🚀 Despliegue

### 1. Configurar Credenciales AWS

```bash
export AWS_PROFILE=tu-perfil-aws
# o
aws configure --profile tu-perfil-aws
```

### 2. Configurar Variables

Editar `environments/dev/terraform.tfvars`:

```hcl
region      = "us-east-1"
profile     = "tu-perfil-aws"
client      = "pragma"
project     = "tu-proyecto"      # ⚠️ CAMBIAR
environment = "dev"
```

### 3. Inicializar y Desplegar

```bash
cd environments/dev

# Inicializar Terraform
terraform init

# Ver plan de cambios
terraform plan

# Aplicar infraestructura (toma ~5-10 minutos)
terraform apply
```

## 🔍 Verificación Post-Despliegue

### Ver Outputs
```bash
# Ver todos los outputs
terraform output

# Outputs específicos
terraform output vpc_id
terraform output subnet_ids
terraform output nat_gateway_id
```

### Verificar Recursos en AWS

**Verificar VPC:**
```bash
aws ec2 describe-vpcs \
  --vpc-ids $(terraform output -raw vpc_id) \
  --profile tu-perfil-aws
```

**Verificar Subnets:**
```bash
aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$(terraform output -raw vpc_id)" \
  --profile tu-perfil-aws
```

**Verificar VPC Endpoints:**
```bash
aws ec2 describe-vpc-endpoints \
  --filters "Name=vpc-id,Values=$(terraform output -raw vpc_id)" \
  --profile tu-perfil-aws
```

## 🎯 Recursos Desplegados

### Networking
- ✅ 1 VPC (10.0.0.0/16)
- ✅ 12 Subnets (4 tipos x 3 AZs)
- ✅ 1 Internet Gateway
- ✅ 1 NAT Gateway Regional
- ✅ Route Tables configuradas

### Security
- ✅ 1 Security Group (VPC Endpoints)
- ✅ Flow Logs habilitados

### VPC Endpoints
- ✅ 2 Gateway Endpoints (S3, DynamoDB)
- ✅ 5 Interface Endpoints (SSM, SSM Messages, EC2 Messages, Secrets Manager, Logs)

## 📊 Outputs

La línea base proporciona los siguientes outputs:

### VPC
- `vpc_id` - ID de la VPC
- `vpc_cidr_block` - CIDR block de la VPC
- `subnet_ids` - Map de IDs de subnets por tipo
- `route_table_ids` - Map de IDs de route tables
- `nat_gateway_id` - ID del NAT Gateway Regional

### Security Groups
- `sg_ids` - Map de IDs de Security Groups
- `sg_arns` - Map de ARNs de Security Groups

### VPC Endpoints
- `vpc_endpoint_ids` - Map de IDs de VPC Endpoints
- `vpc_endpoint_dns_entries` - DNS entries de Interface endpoints

## 💰 Costos Estimados

### Componentes sin costo adicional:
- VPC, Subnets, Route Tables
- Internet Gateway
- Gateway Endpoints (S3, DynamoDB)

### Componentes con costo:
- **NAT Gateway Regional**: ~$32/mes + data transfer
- **Interface Endpoints**: ~$7.20/mes cada uno (~$36/mes total para 5 endpoints)
- **Total estimado**: ~$68/mes (sin contar data transfer)

## 🔒 Seguridad

- ✅ Flow Logs habilitados (retención 7 días)
- ✅ Private DNS habilitado en Interface endpoints
- ✅ Security Groups restrictivos
- ✅ Subnets de base de datos aisladas (sin NAT)
- ✅ Cifrado en tránsito (HTTPS en endpoints)

## 🧹 Limpieza

Para destruir toda la infraestructura:

```bash
cd environments/dev
terraform destroy
```

⚠️ **Advertencia**: Esto eliminará TODA la infraestructura de red.

## 🆘 Troubleshooting

### Error: "No valid credential sources found"
```bash
# Verificar perfil
aws sts get-caller-identity --profile tu-perfil-aws

# Configurar si es necesario
aws configure --profile tu-perfil-aws
```

### Error: "VPC already exists"
```bash
# Verificar estado
terraform state list

# Importar si es necesario
terraform import module.vpc.aws_vpc.this vpc-xxxxx
```

### Error: "Insufficient permissions"
Verificar que tu usuario/rol tenga permisos para:
- EC2 (VPC, Subnets, NAT, Endpoints)
- CloudWatch (Logs)
- IAM (para Flow Logs)

Ver documentación completa: [`iam-permissions/README.md`](./iam-permissions/README.md)

## 📚 Próximos Pasos

Una vez desplegada la red, puedes:
1. Desplegar aplicaciones en las subnets privadas
2. Configurar bases de datos en las subnets database
3. Agregar más VPC Endpoints según necesidad
4. Integrar con otros módulos (EKS, RDS, etc.)

## 📝 Notas

### NAT Gateway Regional
Esta línea base usa el nuevo modo **Regional NAT Gateway** de AWS que ofrece:
- ✨ Un solo NAT Gateway para toda la VPC
- ✨ Alta disponibilidad automática
- ✨ Mayor capacidad (hasta 32 IPs por AZ)
- ✨ Más económico que NAT Gateways zonales

### Personalización
Para agregar más VPC Endpoints, editar `vpc_endpoints` en `terraform.tfvars`:

```hcl
vpc_endpoints = {
  # ... endpoints existentes ...
  
  "kms" = {
    vpc_id              = ""
    service_name        = "com.amazonaws.us-east-1.kms"
    vpc_endpoint_type   = "Interface"
    private_dns_enabled = true
    security_group_ids  = []
    subnet_ids          = []
  }
}
```

## 🆘 Soporte

Para preguntas o issues, contactar al equipo de CloudOps.

## 📚 Referencias

- [CHANGELOG](./CHANGELOG.md) - Historial de cambios
- [Permisos IAM](./iam-permissions/README.md) - Documentación de permisos
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html)
- [Regional NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateways-regional.html)
- [Módulo VPC v1.0.3](https://github.com/somospragma/cloudops-ref-repo-aws-vpc-terraform/releases/tag/v1.0.3)
- [Módulo SG v1.0.1](https://github.com/somospragma/cloudops-ref-repo-aws-sg-terraform/releases/tag/v1.0.1)
- [Módulo VPC Endpoints v1.0.1](https://github.com/somospragma/cloudops-ref-repo-aws-vpc-endpoint-terraform/releases/tag/v1.0.1)
