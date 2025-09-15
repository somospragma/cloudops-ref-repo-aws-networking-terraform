# **Módulo Terraform: cloudops-ref-repo-aws-persistence-terraform**

## Descripción:

Este módulo combina 3 sub módulos (rds, kms y security groups) los cuales permiten:

rds:

- Crear un cluster rds global
- Crear un cluster rds principal
- Crear un cluster rds secundario
- Crear una instancia del cluster rds principal
- Crear una instancia del cluster rds secundario
- Crear un subnet group para cluster rds principal
- Crear un subnet group para cluster rds secundario
- Crear un parameter group para la bd primaria
- Crear un parameter group para la bd secundaria
- Crear un parameter group para cluster rds primario
- Crear un parameter group para cluster rds secundario

kms:

- Crear a key para el password de la bd.

security groups:

- Crear security groups.


Consulta CHANGELOG.md para la lista de cambios de cada versión. *Recomendamos encarecidamente que en tu código fijes la versión exacta que estás utilizando para que tu infraestructura permanezca estable y actualices las versiones de manera sistemática para evitar sorpresas.*

## Estructura del Módulo
El módulo cuenta con la siguiente estructura:

```bash
cloudops-ref-repo-aws-persistence-terraform/
└── environments/dev
    ├── terraform.tfvars
├── .gitignore
├── .terraform.lock.hcl
├── CHANGELOG.md
├── data.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── README.md
├── variables.tf
```

- Los archivos principales del módulo (`data.tf`, `main.tf`, `outputs.tf`, `variables.tf`, `providers.tf`) se encuentran en el directorio raíz.
- `CHANGELOG.md` y `README.md` también están en el directorio raíz para fácil acceso.
- La carpeta `sample/` contiene un ejemplo de implementación del módulo.

## Seguridad & Cumplimiento
 
Consulta a continuación la fecha y los resultados de nuestro escaneo de seguridad y cumplimiento.
 
<!-- BEGIN_BENCHMARK_TABLE -->
| Benchmark | Date | Version | Description | 
| --------- | ---- | ------- | ----------- | 
| ![checkov](https://img.shields.io/badge/checkov-passed-green) | 2023-09-20 | 3.2.232 | Escaneo profundo del plan de Terraform en busca de problemas de seguridad y cumplimiento |
<!-- END_BENCHMARK_TABLE -->

## Provider Configuration

Este módulo requiere la configuración de un provider específico para el proyecto. Debe configurarse de la siguiente manera:

```hcl
sample/persistence/providers.tf
provider "aws" {
  alias = "alias01"
  # ... otras configuraciones del provider
}

sample/persistence/main.tf
module "vpc" {
  source = ""
  providers = {
    aws.project = aws.alias01
  }
  # ... resto de la configuración
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.project"></a> [aws.project](#provider\_aws) | >= 4.31.0 |

## IAM Permissions

Este repositorio requiere el siguiente rol IAM:
- **Rol**: `TerraformPersistenceRole`
- **Política**: `iam-policies/persistence-policy.json`

### Permisos Incluidos
- RDS: Gestión completa de clusters, instancias y snapshots
- VPC: Acceso de lectura a VPCs, subredes y security groups
- KMS: Acceso de lectura para cifrado
- CloudWatch Logs: Gestión de grupos de logs
- Terraform State: Acceso al backend S3 y DynamoDB

## References (PENDIENTE)

| Module | Use | Resources | Varibales | Outputs |
|------| ----- |------| ----- | ----- |
| vpc | [Ver]() | [Ver]() | [Ver]() | [Ver]() |
| vpc endpoints | [Ver]() | [Ver]() | [Ver]() | [Ver]() |
| security groups | [Ver]() | [Ver]() | [Ver]() | [Ver]() |

