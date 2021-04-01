terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_cognito_user_pool" "userpool" {
  name              = "imageUploader"
  mfa_configuration = "ON"

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  alias_attributes = ["email"]

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 12
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
  }

  software_token_mfa_configuration {
    enabled = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_client" "testpoolclient" {
  name         = "testClient"
  user_pool_id = aws_cognito_user_pool.userpool.id

  logout_urls                  = ["http://localhost"]
  supported_identity_providers = ["COGNITO"]
}


