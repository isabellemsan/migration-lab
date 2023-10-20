terraform {
  required_providers {
    aws = {
     
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {
    region         = "eu-central-1"
    bucket         = "capci-isabelle-bucket2023"
    key            = "capci/migration.tfstates"
    dynamodb_table = "tf-state-capci-isabelle"
    encrypt        = "true"
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = local.region
  default_tags {
    tags = merge(
      local.tags
    )
  }
}