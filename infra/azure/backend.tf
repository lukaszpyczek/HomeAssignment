terraform {
  backend "azurerm" {
    resource_group_name  = "home-assignment"
    storage_account_name = "homeassitfstate"
    container_name       = "tfstate"
    key                  = "aks/terraform.tfstate"
  }
}
