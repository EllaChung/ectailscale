locals {
    vm_install = templatefile("${path.module}/tailscale-install.tftpl",
    {
        tailscale_auth_key = var.tailscale_auth_key,
        
        before_scripts = flatten([
            var.additional_before_scripts,
            local.ip_forwarding_script,
        ])
    }
    )
}