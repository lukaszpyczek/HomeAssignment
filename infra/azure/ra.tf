data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_role_assignment" "ra1" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_user_assigned_identity.ingress.principal_id
}

resource "azurerm_role_assignment" "ra2" {
  scope                = azurerm_virtual_network.this.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_user_assigned_identity.ingress.principal_id
}

resource "azurerm_role_assignment" "ra3" {
  scope                = azurerm_application_gateway.this.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.ingress.principal_id
}
