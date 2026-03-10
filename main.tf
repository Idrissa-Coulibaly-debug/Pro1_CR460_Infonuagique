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
    random = {
      source  = "hashicorp/random"
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
  location = "canadaeast"
}

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

# Interface réseau pour la VM
resource "azurerm_network_interface" "nic_vm_demo" {
  name                = "idrissa-coulibaly-nic"
  location            = azurerm_resource_group.rg_test.location
  resource_group_name = azurerm_resource_group.rg_test.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Machine Virtuelle (Ubuntu)
resource "azurerm_linux_virtual_machine" "idrissa_vm_demo" {
  name                            = "idrissa-coulibaly-vm"
  resource_group_name             = azurerm_resource_group.rg_test.name
  location                        = azurerm_resource_group.rg_test.location
  size                            = "Standard_D2s_v5"

  admin_username                  = "azureuser"
  admin_password                  = "Infected123!"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic_vm_demo.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

# Q10 - Déploiement d’un container Docker via pipeline dans MS Azure
resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_container_group" "nginx_demo" {
  name                = "coulibaly-idrissa-nginx-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg_test.location
  resource_group_name = azurerm_resource_group.rg_test.name
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "coulibaly-idrissa-hello-${random_string.suffix.result}"
  restart_policy      = "Always"

  container {
    name   = "helloworld"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.0"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    environment = "lab"
    owner       = "coulibaly-idrissa"
    question    = "Q10"
  }
}

# Outputs utiles
output "aci_fqdn" {
  value       = azurerm_container_group.nginx_demo.fqdn
  description = "FQDN du conteneur ACI - Ouvrez http://<cette-valeur> dans votre navigateur après apply"
}

output "aci_ip" {
  value       = azurerm_container_group.nginx_demo.ip_address
  description = "Adresse IP publique du conteneur (si FQDN ne résout pas immédiatement)"
}
