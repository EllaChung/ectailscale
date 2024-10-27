# Addresses the main resource group
locals {
    resource_group_name = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location
}

# Details of resource group location
resource "azurerm_resource_group" "main" {
    location = "eastus"
    type = "Microsoft.Network/networkSecurityGroups",
    apiVersion = "2024-01-01",
    name = [parameters("networkSecurityGroups_ts_ubuntu_vm_nsg_name")],
            properties = {
                securityRules = [
                    {
                        name = "Tailscale",
                        id = "[resourceId('Microsoft.Network/networkSecurityGroups/securityRules', parameters('networkSecurityGroups_ts_ubuntu_vm_nsg_name'), 'Tailscale')]",
                        type = "Microsoft.Network/networkSecurityGroups/securityRules",
                        properties = {
                            description = "Tailscale UDP port",
                            protocol = "UDP",
                            sourcePortRange = "*",
                            destinationPortRange = "41641",
                            sourceAddressPrefix = "*",
                            destinationAddressPrefix = "*",
                            access = "Allow",
                            priority = 1010,
                            direction = "Inbound",
                            sourcePortRanges = [],
                            destinationPortRanges = [],
                            sourceAddressPrefixes = [],
                            destinationAddressPrefixes = []
                        }
                    }
                ]
            }
}

# Pulling source for Azure virtual environment
module "virtual-env" {
    source = "../"
}

# Tailscale related key that does not expire and recreates if invalid
resource "tailscale_tailnet_key" "main" {
    preauthorized = true
    reusable = true
    recreate_if_invalid = "always"
}

module "tailscale_azure_vm" {
    source = "../"

    location = local.location
    resource_group_name = local.resource_group_name

    # Creating public subnet
    primary_subnet_id = local.subnet_id
    network_security_group_id = local.network_security_group_id

    machine_name = local.name
    machine_size = local.instance_type
    admin_public_key_path = local.admin_public_key_path
}

# Set inbound security rule
resource "azurerm_network_security_group" "ingress_rule" {
    location = local.location
    resource_group_name = local.resource_group_name

    name = "takehome-tailscale-ingress-nsg"

    security_rule = {
        name = "AllowTailscaleInbound"
        access = "Allow"
        direction = "Inbound"
        priority = "1010"
        protocol = "UDP"
        source_address_prefix = "Internet"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "41641"
    }
}
