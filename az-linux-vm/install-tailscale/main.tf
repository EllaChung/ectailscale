module "tailscale_install_scripts" {
    source = "../../../internal-modules/tailscale-install-scripts"

    tailscale_auth_key        = var.tailscale_auth_key
    tailscale_hostname        = var.tailscale_hostname
    tailscale_set_preferences = var.tailscale_set_preferences

    additional_before_scripts = var.additional_before_scripts
    additional_after_scripts  = var.additional_after_scripts
}

resource "azurerm_network_interface" "testing" {
    location = var.location
    resource_group_name = var.resource_group_name

    name = "${var.machine_name}-testing"
}

