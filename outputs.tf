output "s3_bucket" {
  value = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table" {
  value = aws_dynamodb_table.terraform_lock.id
}

output "terraform_admin_role_arn" {
  value = aws_iam_role.terraform_admin.arn
}