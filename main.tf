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

# Déploiement de Réseau Virtuel à partir de votre pipeline dans MS Azure

# VNET
resource "azurerm_virtual_network" "vnet" {
  name                = "idrissa-coulibaly-vnet"
  location            = azurerm_resource_group.rg_test.location
  resource_group_name = azurerm_resource_group.rg_test.name
  address_space       = ["10.10.0.0/16"]
}

# SUBNET
resource "azurerm_subnet" "subnet_vm" {
  name                 = "idrissa-coulibaly-subnet-vm"
  resource_group_name  = azurerm_resource_group.rg_test.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

