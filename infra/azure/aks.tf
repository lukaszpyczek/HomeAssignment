resource "azurerm_kubernetes_cluster" "this" {
  name                              = var.aks_cluster_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  dns_prefix                        = var.aks_cluster_name
  private_cluster_enabled           = var.aks_private_cluster_enabled
  role_based_access_control_enabled = var.aks_enable_rbac
  sku_tier                          = var.aks_sku_tier


  network_profile {
    network_plugin = "azure"
    dns_service_ip = var.aks_dns_service_ip
    service_cidr   = var.aks_service_cidr
  }

  default_node_pool {
    name            = "default"
    node_count      = var.aks_node_count
    vm_size         = var.aks_vm_size
    os_disk_size_gb = var.aks_os_disk_size
    vnet_subnet_id  = data.azurerm_subnet.akssubnet.id
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }
  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.this.id
  }
  depends_on = [
    azurerm_application_gateway.this
  ]
}

resource "azurerm_public_ip" "this" {
  name                = "app_gw-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "this" {
  name                = var.app_gw_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku {
    name     = var.app_gw_tier
    tier     = var.app_gw_tier
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = data.azurerm_subnet.appgwsubnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }


  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.this.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 1
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  lifecycle {
    ignore_changes = [
      tags,
      backend_address_pool,
      backend_http_settings,
      http_listener,
      probe,
      request_routing_rule
    ]
  }
}
