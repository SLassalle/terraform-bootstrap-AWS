provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "bootstrap"
  }
}

resource "aws_dynamodb_table" "terraform_lock_iam" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "bootstrap"
  }
}

resource "aws_iam_role" "terraform_admin" {
  name = var.role_name

  assume_role_policy = data.aws_iam_policy_document.terraform_trust.json
}

data "aws_iam_policy_document" "terraform_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

resource "aws_iam_policy" "terraform_policy" {
  name   = "TerraformAdministratorPolicy"
  policy = data.aws_iam_policy_document.terraform_permissions.json
}

data "aws_iam_policy_document" "terraform_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "iam:*",
      "s3:*",
      "dynamodb:*",
      "ec2:*",
      "sts:AssumeRole"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.terraform_admin.name
  policy_arn = aws_iam_policy.terraform_policy.arn
}