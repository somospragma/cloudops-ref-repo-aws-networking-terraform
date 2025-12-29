# Permisos IAM Requeridos

Este documento detalla los permisos IAM necesarios para desplegar y gestionar la línea base de networking Pragma.

## 📋 Resumen de Permisos

Para desplegar esta infraestructura, el usuario/rol de IAM necesita permisos para:

1. **VPC y Networking** - Crear y gestionar VPC, subnets, route tables, gateways
2. **Security Groups** - Crear y gestionar security groups y reglas
3. **VPC Endpoints** - Crear y gestionar VPC endpoints (Gateway e Interface)
4. **CloudWatch Logs** - Crear log groups para VPC Flow Logs
5. **IAM** - Crear roles de servicio para Flow Logs
6. **EC2** - Gestionar recursos de red (EIPs, ENIs)

## 🔐 Políticas IAM

### Opción 1: Política Mínima Requerida (Recomendada)

Usa la política personalizada en: [`networking-deployment-policy.json`](./networking-deployment-policy.json)

Esta política incluye **solo** los permisos necesarios para desplegar esta línea base.

**Aplicar la política:**
```bash
# Crear la política
aws iam create-policy \
  --policy-name PragmaNetworkingDeploymentPolicy \
  --policy-document file://iam-permissions/networking-deployment-policy.json

# Adjuntar a un usuario
aws iam attach-user-policy \
  --user-name tu-usuario \
  --policy-arn arn:aws:iam::ACCOUNT-ID:policy/PragmaNetworkingDeploymentPolicy

# O adjuntar a un rol
aws iam attach-role-policy \
  --role-name tu-rol \
  --policy-arn arn:aws:iam::ACCOUNT-ID:policy/PragmaNetworkingDeploymentPolicy
```

### Opción 2: Políticas AWS Managed (Más Permisiva)

Si prefieres usar políticas administradas por AWS:

```bash
# Adjuntar políticas managed
aws iam attach-user-policy \
  --user-name tu-usuario \
  --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess

aws iam attach-user-policy \
  --user-name tu-usuario \
  --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess

aws iam attach-user-policy \
  --user-name tu-usuario \
  --policy-arn arn:aws:iam::aws:policy/IAMFullAccess
```

⚠️ **Advertencia**: Estas políticas otorgan más permisos de los necesarios. Usa la Opción 1 para seguir el principio de menor privilegio.

## 📝 Permisos Detallados por Recurso

### VPC y Subnets
```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:CreateVpc",
    "ec2:DeleteVpc",
    "ec2:DescribeVpcs",
    "ec2:ModifyVpcAttribute",
    "ec2:CreateSubnet",
    "ec2:DeleteSubnet",
    "ec2:DescribeSubnets",
    "ec2:ModifySubnetAttribute",
    "ec2:CreateTags",
    "ec2:DeleteTags",
    "ec2:DescribeTags"
  ],
  "Resource": "*"
}
```

### Internet Gateway y NAT Gateway
```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:CreateInternetGateway",
    "ec2:DeleteInternetGateway",
    "ec2:AttachInternetGateway",
    "ec2:DetachInternetGateway",
    "ec2:DescribeInternetGateways",
    "ec2:CreateNatGateway",
    "ec2:DeleteNatGateway",
    "ec2:DescribeNatGateways",
    "ec2:AllocateAddress",
    "ec2:ReleaseAddress",
    "ec2:DescribeAddresses"
  ],
  "Resource": "*"
}
```

### Route Tables
```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:CreateRouteTable",
    "ec2:DeleteRouteTable",
    "ec2:DescribeRouteTables",
    "ec2:CreateRoute",
    "ec2:DeleteRoute",
    "ec2:ReplaceRoute",
    "ec2:AssociateRouteTable",
    "ec2:DisassociateRouteTable"
  ],
  "Resource": "*"
}
```

### Security Groups
```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:CreateSecurityGroup",
    "ec2:DeleteSecurityGroup",
    "ec2:DescribeSecurityGroups",
    "ec2:AuthorizeSecurityGroupIngress",
    "ec2:AuthorizeSecurityGroupEgress",
    "ec2:RevokeSecurityGroupIngress",
    "ec2:RevokeSecurityGroupEgress",
    "ec2:ModifySecurityGroupRules"
  ],
  "Resource": "*"
}
```

### VPC Endpoints
```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:CreateVpcEndpoint",
    "ec2:DeleteVpcEndpoints",
    "ec2:DescribeVpcEndpoints",
    "ec2:ModifyVpcEndpoint",
    "ec2:DescribeVpcEndpointServices",
    "ec2:DescribePrefixLists"
  ],
  "Resource": "*"
}
```

### VPC Flow Logs
```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:CreateFlowLogs",
    "ec2:DeleteFlowLogs",
    "ec2:DescribeFlowLogs",
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
    "logs:DescribeLogGroups",
    "logs:DescribeLogStreams",
    "iam:CreateRole",
    "iam:PutRolePolicy",
    "iam:AttachRolePolicy",
    "iam:PassRole"
  ],
  "Resource": "*"
}
```

## 🧪 Verificar Permisos

Antes de desplegar, verifica que tienes los permisos necesarios:

```bash
# Verificar identidad
aws sts get-caller-identity

# Simular permisos (requiere iam:SimulatePrincipalPolicy)
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::ACCOUNT-ID:user/tu-usuario \
  --action-names ec2:CreateVpc ec2:CreateSubnet ec2:CreateNatGateway \
  --resource-arns "*"
```

## 🔒 Mejores Prácticas de Seguridad

### 1. Usar Roles en lugar de Usuarios
```bash
# Crear rol para Terraform
aws iam create-role \
  --role-name TerraformNetworkingRole \
  --assume-role-policy-document file://trust-policy.json

# Adjuntar política
aws iam attach-role-policy \
  --role-name TerraformNetworkingRole \
  --policy-arn arn:aws:iam::ACCOUNT-ID:policy/PragmaNetworkingDeploymentPolicy
```

### 2. Usar MFA para Operaciones Sensibles
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DeleteVpc",
      "Resource": "*",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
```

### 3. Limitar por Tags
```json
{
  "Effect": "Allow",
  "Action": "ec2:*",
  "Resource": "*",
  "Condition": {
    "StringEquals": {
      "aws:RequestedRegion": "us-east-1",
      "ec2:ResourceTag/ManagedBy": "Terraform"
    }
  }
}
```

### 4. Usar Credenciales Temporales
```bash
# Asumir rol con credenciales temporales
aws sts assume-role \
  --role-arn arn:aws:iam::ACCOUNT-ID:role/TerraformNetworkingRole \
  --role-session-name terraform-session
```

## 📊 Matriz de Permisos por Operación

| Operación | Permisos Requeridos | Criticidad |
|-----------|-------------------|------------|
| `terraform plan` | Read-only (Describe*) | Baja |
| `terraform apply` | Create*, Modify*, Delete* | Alta |
| `terraform destroy` | Delete*, Describe* | Crítica |
| Ver outputs | Describe* | Baja |

## 🆘 Troubleshooting

### Error: "User is not authorized to perform: ec2:CreateVpc"
**Solución**: Adjuntar la política de networking o verificar permisos.

### Error: "User is not authorized to perform: iam:PassRole"
**Solución**: Agregar permiso `iam:PassRole` para el rol de Flow Logs.

### Error: "Access Denied" al crear VPC Endpoints
**Solución**: Verificar permisos `ec2:CreateVpcEndpoint` y `ec2:DescribeVpcEndpointServices`.

## 📚 Referencias

- [AWS VPC IAM Permissions](https://docs.aws.amazon.com/vpc/latest/userguide/security-iam.html)
- [VPC Endpoints IAM](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints-iam.html)
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Least Privilege Principle](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#grant-least-privilege)

## 🔄 Actualización de Permisos

Si agregas nuevos recursos a la línea base, actualiza:
1. La política en `networking-deployment-policy.json`
2. Este documento README
3. Incrementa la versión de la política
