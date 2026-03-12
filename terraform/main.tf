terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  backend "s3" {
    bucket = "artemis-test-tf-state"
    key    = "infra/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  default = "us-east-1"
}

resource "aws_iam_role" "github_actions_deployer" {
  name = "github-actions-deployer"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com" }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = { StringLike = { "token.actions.githubusercontent.com:sub" = "repo:Artemis-Test/*:*" } }
    }]
  })
}

data "aws_caller_identity" "current" {}
