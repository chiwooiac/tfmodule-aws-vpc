terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }

}

provider "aws" {
  region                  = "ap-northeast-2"
  # profile                 = "terran"
  # shared_credentials_file = "$HOME/.aws/credentials"
}
