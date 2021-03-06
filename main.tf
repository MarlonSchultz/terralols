terraform {
  backend "remote" {
    organization = "MarlonSchultz"

    workspaces {
      name = "ImageUploader"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
}

resource "aws_cognito_user_pool" "userpool" {
  name              = "imageUploader"
  mfa_configuration = "ON"

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  schema {
    name                     = "nickname"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    required                 = true
    string_attribute_constraints {
      min_length = 5
      max_length = 40
    }
  }

  password_policy {
    minimum_length    = 12
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
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

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "bimmelbommelyolo"
  user_pool_id = aws_cognito_user_pool.userpool.id
}

resource "aws_cognito_user_pool_client" "testpoolclient" {
  name         = "testClient"
  user_pool_id = aws_cognito_user_pool.userpool.id

  logout_urls   = ["http://localhost"]
  callback_urls = ["http://localhost"]

  explicit_auth_flows = ["ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
  "ALLOW_USER_SRP_AUTH", ]
  allowed_oauth_scopes = [
    "aws.cognito.signin.user.admin",
  ]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = [
    "code", "implicit"
  ]
  supported_identity_providers = ["COGNITO"]
}




