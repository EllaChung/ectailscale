# ectailscale
Infrastructure as Code solution for creating a personal Tailnet, deploying a subnet router and Tailscale device with SSH enabled.

### Main deployment environment used a MacOS and Android mobile device.
---
#### Logic of Hierarchies Explained
- "az-linux-vm" is intended for automated deployment of Azure vm, subnet, and NSG within resource group "takehome":
    - "install-vm" contains "main.tf" used to be the main Terraform configuration file
    - "azuredeploy.json" is the exported file from manually deployed Azure vm
    - "main.tf' is the initial attempt at automating Azure vm. It includes resources for creating the vnet, subnet and inbound security rule for Tailscale
    - "parameters.json" is pulled from an example for reference
    - "template.json" is the json also exported from Azure after manual deployment
    - "vm_template" is the vm only config exported from Azure after manual deployment
---
- "install-tailscale" is inteded for automated deployment of Tailscale for the Azure vm
    - "main.tf" is intended to be the main Terraform configuration file that would call the template with info on installing Tailscale
    - "tailscale-install.tftpl" is the Terraform template for the curl commands needed to install tailscale onto the ubuntu environment
--- 
- "terraform-linux-vm" should create a Linux VM in Azure via Terraform
