
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "idp" {
  name     = "rg-ai-idp-dev"
  location = "centralindia"

  tags = {
    project     = "ai-powered-idp"
    environment = "dev"
    managed_by  = "terraform"
  }
}

# Virtual Network for the IDP
resource "azurerm_virtual_network" "idp" {
  name                = "vnet-ai-idp-dev"
  location            = azurerm_resource_group.idp.location
  resource_group_name = azurerm_resource_group.idp.name
  address_space       = ["10.40.0.0/16"]

  tags = {
    project     = "ai-powered-idp"
    environment = "dev"
  }
}

# Subnet for AKS
resource "azurerm_subnet" "aks" {
  name                 = "snet-aks-dev"
  resource_group_name  = azurerm_resource_group.idp.name
  virtual_network_name = azurerm_virtual_network.idp.name
  address_prefixes     = ["10.40.1.0/24"]
}

# Azure Container Registry
resource "azurerm_container_registry" "idp" {
  name                = "acraidpdev${random_string.acr_suffix.result}"
  resource_group_name = azurerm_resource_group.idp.name
  location            = azurerm_resource_group.idp.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    project     = "ai-powered-idp"
    environment = "dev"
  }
}

# Unique suffix for ACR name
resource "random_string" "acr_suffix" {
  length  = 6
  upper   = false
  special = false
}
