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