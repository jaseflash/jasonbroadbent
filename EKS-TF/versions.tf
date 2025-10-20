terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.16.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.2.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
  }

  required_version = "~> 1.13.3"
}

