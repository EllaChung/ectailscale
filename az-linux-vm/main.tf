/*
terraform {
    required_providers {
        azure = {
            source = "RENAME THIS"
            version = "FILL IN CORRECT VERSION"
        }
    }
}


variable "az_token" {}
variable "tailscale_auth_key" {}

provider "azure" {
    token = var.az_token
}
resource "azure_vm" "virtualm" {
    image = "ubuntu-20-04-x64"
    name = "nyc1-terraform-caddy"
    region = "eastus"
    size = ""
    ssh_keys = []
    # The following is injecting CloudInit directly using Tailscale resource using template tftpl
    userdata = templatefile("azuredeployment.tftpl", { tailscale_auth_key = var.tailscale_auth_key})
}
*/

# VM on Azure via: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_resource_group" "takehome" {
    name = "takehome-resources"
    location = "East US"
}

#Creating a NSG
resource "azurerm_network_security_group" "takehome_nsg" {
    name = "takehome-nsg"
    location = azurerm_resource_group.takehome.location
    resource_group_name = azurerm_resource_group.takehome.name
}

# Creating a vnet
resource "azurerm_virtual_network" "takehome" {
    name = "takehome-vnet"
    location = azurerm_resource_group.takehome.location
    resource_group_name = azurerm_resource_group.takehome.name
    address_space = ["10.0.0.0/24"]
}

# Creating a subnet
resource "azurerm_subnet" "takehome" {
    name = "takehome-subnet"
    location = azurerm_resource_group.takehome.location
    resource_group_name = azurerm_resource_group.takehome.name
    virtual_network_name = azurerm_virtual_network.takehome.name
    address_prefixes = ["10.1.0.0/24"]
}

# Set inbound security rule
resource "azurerm_network_security_rule" "takehome-nsg" {
    name = "Tailscale"
    description = "Tailscale UDP port"
    priority = 1010
    direction = "Inbound"
    access = "Allow"
    protocol = "UDP"
    source_port_range = "*"
    destination_port_range = 41641
    source_address_prefix = "*"
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.takehome.name
    network_security_group_name = azurerm_network_security_group.takehome_nsg.name
}




