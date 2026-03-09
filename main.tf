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
  name                = "idrissa-coulibaly-vm"
  resource_group_name = azurerm_resource_group.rg_test.name
  location            = azurerm_resource_group.rg_test.location
  size                = "Standard_B1ms"

  admin_username = "azureuser"
  admin_password = "Infected123!"

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
resource "azurerm_linux_virtual_machine" "idrissa_vm_demo" {
  name                = "idrissa-coulibaly-vm"
  resource_group_name = azurerm_resource_group.rg_test.name
  location            = azurerm_resource_group.rg_test.location
  size                = "Standard_B1ms"

  admin_username = "azureuser"
  admin_password = "Infected123!"

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
resource "azurerm_linux_virtual_machine" "idrissa_vm_demo" {
  name                = "idrissa-coulibaly-vm"
  resource_group_name = azurerm_resource_group.rg_test.name
  location            = azurerm_resource_group.rg_test.location
  size                = "Standard_B1ms"

  admin_username = "azureuser"
  admin_password = "Infected123!"

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


