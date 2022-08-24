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
  name                = "aks"
  location            = azurerm_resource_group.resource_live.location
  resource_group_name = azurerm_resource_group.resource_live.name
  dns_prefix          = "labs"
  kubernetes_version  = "1.24.0"

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
  name                = "studieslabsacr"
  resource_group_name = azurerm_resource_group.resource_live.name
  location            = azurerm_resource_group.resource_live.location
  sku                 = "Premium"
  admin_enabled       = false
}


resource "azurerm_role_assignment" "acr_role" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks_labs.kubelete_identity[0].object
  skip_service_principal_aad_check = true
}
