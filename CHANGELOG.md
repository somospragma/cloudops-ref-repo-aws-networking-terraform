# Changelog - Línea Base Networking Pragma

Todos los cambios notables en esta línea base serán documentados en este archivo.

## [1.0.1] - 2025-12-29

### 🔧 Actualización de Módulos
- **VPC Module**: Actualizado de v1.0.2 a v1.0.3
  - Incluye documentación de permisos IAM
- **VPC Endpoints Module**: Actualizado de v1.0.0 a v1.0.1
  - Incluye documentación de permisos IAM
- **Security Groups Module**: Actualizado de v1.0.0 a v1.0.1
  - Incluye documentación de permisos IAM

### 📚 Mejoras
- Todos los módulos ahora incluyen documentación completa de permisos IAM
- Políticas JSON listas para aplicar en cada módulo

## [1.0.0] - 2024-12-29

### 🎉 Primera Versión - Línea Base Pragma

Línea base de networking para proyectos Pragma con configuración estándar y módulos certificados.

### ✨ Características

#### VPC Configuration
- **NAT Gateway Regional**: Modo regional de AWS para alta disponibilidad y menor costo
- **4 Tipos de Subnets**: Public, Private, Service, Database
- **3 Availability Zones**: us-east-1a, us-east-1b, us-east-1c
- **CIDR Block**: 10.0.0.0/16
- **Flow Logs**: Habilitados con retención de 7 días

#### VPC Endpoints BASE
**Gateway Endpoints (sin costo):**
- S3 - Almacenamiento y backups
- DynamoDB - Base de datos NoSQL

**Interface Endpoints (con costo):**
- SSM - Systems Manager y Parameter Store
- SSM Messages - Session Manager
- EC2 Messages - Session Manager
- Secrets Manager - Gestión de secretos
- CloudWatch Logs - Centralización de logs

#### Security Groups
- Security Group base para VPC Endpoints
- Reglas restrictivas (solo HTTPS desde VPC)

### 📦 Módulos Utilizados

| Módulo | Versión | Cambios |
|--------|---------|---------|
| VPC | v1.0.2 | Regional NAT Gateway support |
| Security Groups | v1.0.0 | PC-IAC compliance |
| VPC Endpoints | v1.0.0 | PC-IAC compliance |

### 🔧 Configuración

#### Subnets Distribution
```
Public:    10.0.1.0/24,  10.0.2.0/24,  10.0.3.0/24
Private:   10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24
Service:   10.0.21.0/24, 10.0.22.0/24, 10.0.23.0/24
Database:  10.0.31.0/24, 10.0.32.0/24, 10.0.33.0/24
```

#### NAT Gateway
- **Modo**: Regional (nuevo de AWS)
- **Configuración**: Automática
- **Alta Disponibilidad**: Sí (automática por AWS)

### 💰 Costos Estimados

- NAT Gateway Regional: ~$32/mes
- Interface Endpoints (5): ~$36/mes
- **Total**: ~$68/mes (sin data transfer)

### 🎯 Diferencias con Línea Base EKS

Esta línea base **NO incluye**:
- ❌ Tags específicos de EKS (`kubernetes.io/role/*`)
- ❌ Endpoints específicos de EKS (eks, ecr-api, ecr-dkr, ec2, sts)
- ❌ Configuraciones específicas para pods de EKS

Esta línea base **SÍ incluye**:
- ✅ Endpoints base universales (SSM, Secrets Manager, Logs)
- ✅ NAT Gateway Regional
- ✅ 4 tipos de subnets estándar
- ✅ Configuración lista para cualquier tipo de aplicación

### 📝 Uso

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### 🔒 Seguridad

- Flow Logs habilitados
- Private DNS en Interface endpoints
- Security Groups restrictivos
- Subnets de database aisladas (sin NAT)
- Cifrado en tránsito (HTTPS)

### 📚 Documentación

Ver [README.md](./README.md) para documentación completa.
