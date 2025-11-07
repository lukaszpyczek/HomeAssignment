variable "aks_cluster_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "aks_subnet_name" {
  type = string
}

variable "aks_subnet_address_prefix" {
  type = list(string)
}

variable "app_gw_subnet_name" {
  type = string
}
variable "app_gw_subnet_address_prefix" {
  type = list(string)
}

variable "virtual_network_name" {

  type = string
}

variable "virtual_network_address_prefix" {
  type = string
}
variable "app_gw_tier" {
  type = string
}

variable "app_gw_name" {
  type = string
}

variable "aks_vm_size" {
  type = string
}

variable "aks_os_disk_size" {
  type = number
}

variable "aks_node_count" {
  type = number
}

variable "aks_service_cidr" {
  type = string
}

variable "aks_dns_service_ip" {
  type = string
}

variable "aks_sku_tier" {
  type = string
}

variable "aks_enable_rbac" {
  type = bool
}

variable "aks_private_cluster_enabled" {
  type = bool
}
