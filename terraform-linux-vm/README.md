# Explanation of Logic
- In theory this subrepo "terraform-linux-vm" should create a Linux VM in Azure via Terraform. 
    - However, due to an error when running terraform plan -out main.tfplan, it is untestable.
    - Error: unable to build authorizer for Resource Manager API: could not configure AzureCli Authorizer: could not parse Azure CLI version: launching Azure CLI: exec: "az": executable file not found in $PATH) 
---
Next steps would be to:
- Include script to install Tailscale onto the VM
- Advertise the subnets to the configured Tailnet
- Designate one machine as a subnet router