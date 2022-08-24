terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.19.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_live" {
  name     = "labs-aks"
  location = "Brazil South"
}

resource "azurerm_kubernetes_cluster" "aks_labs" {
  name                = "example-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    zones      = [1, 2, 3]
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {}
}

resource "azurerm_container_registry" "acr" {
  name                = "labsacr"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Premium"
  admin_enabled       = false
}


resource "azurerm_role_assignment" "acr_role" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.example.object_id
}