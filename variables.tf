variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-3"
}

variable "s3_bucket_name" {
  description = "Nom du bucket S3 pour stocker l'état Terraform"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Nom de la table DynamoDB pour le lock Terraform"
  type        = string
}

variable "role_name" {
  description = "Nom du rôle IAM Terraform admin"
  default     = "TerraformAdministrator"
}

variable "trusted_principal_arn" {
  description = "ARN du principal autorisé à assumer le rôle (GitHub OIDC ou utilisateur IAM)"
  type        = string
}