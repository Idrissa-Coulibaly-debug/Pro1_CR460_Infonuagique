terraform {
  cloud {
    organization = "Pipeline_CI_CD_Idrissa_Coulibaly"

    workspaces {
      name = "Pro1_CR460_Infonuagique"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}

output "confirmation" {
  value = "Terraform Cloud est correctement connecté à Azure et GitHub grâce au pipeline CI/CD."
}

# Déploiement de ressource groupe à partir de votre pipeline dans MS Azure
resource "azurerm_resource_group" "rg_test" {
  name     = "rg-terraform-Idrissa_Coulibaly"
  location = "eastus"
}
