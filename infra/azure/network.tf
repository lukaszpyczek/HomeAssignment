data "azurerm_subnet" "akssubnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = azurerm_virtual_network.this.name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "appgwsubnet" {
  name                 = var.app_gw_subnet_name
  virtual_network_name = azurerm_virtual_network.this.name
  resource_group_name  = var.resource_group_name
}

data "azurerm_user_assigned_identity" "ingress" {
  name                = "ingressapplicationgateway-${azurerm_kubernetes_cluster.this.name}"
  resource_group_name  = azurerm_kubernetes_cluster.this.node_resource_group
}

resource "azurerm_virtual_network" "this" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.virtual_network_address_prefix]

  subnet {
    name             = var.aks_subnet_name
    address_prefixes = var.aks_subnet_address_prefix
  }

  subnet {
    name             = var.app_gw_subnet_name
    address_prefixes = var.app_gw_subnet_address_prefix
  }
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

