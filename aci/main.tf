provider "azurerm" {
  features {}
}
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "tfstate123456789"
    container_name       = "tfstatedevops2806"
    key                  = "tfstatedevops.tfstate"
  }
}
variable "location" {
  type        = string
  description = "Location of Azure resources"
  default     = "canadaeast"
}
variable "resource_group_name" {
  type        = string
  description = "Resource Group name to where resources are going to be deployed"
  default     = "test"
}
variable "container_group_name" {
  type        = string
  description = "aci name"
  default     = "nginx"
}
variable "container_group_dns" {
  type        = string
  description = "aci name"
  default     = "nginx221851544"
}
resource "azurerm_resource_group" "demo" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_container_group" "aci" {
  name                = var.container_group_name
  resource_group_name = var.resource_group_name
  location            = var.location
  ip_address_type     = "Public"
  dns_name_label      = var.container_group_dns
  os_type             = "Linux"
  container {
    name   = "nginx"
    image  = "nginx:latest"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
  depends_on = [
    azurerm_resource_group.demo,
  ]
}
