<#

Develop an Infrastructure as Code template that can deploy:

- A compute resource (e.g. virtual machine, container based solution etc.)
- A Security Group or Network Security group (or some other access restricting solution - e.g. firewall) 
  that allows only SSH/RDP/HTTP(S) to your public IP address

The template should be for AWS or Azure.
The template can be created using any IaC language you like (e.g. Terraform, CloudFormation, ARM etc.)
The template should allow a user to deploy this for multiple environments with minimal effort.

#>


az login

Clear-Host
$subName = Read-Host "Please enter the subsription"
az account set --subscription $subName

# Create a resource group in your subscription
$rgName = Read-Host "Please enter a name for a new resource group "
az group create --name $rgName --location "Australia East"

# Specify template path
$templateFile="C:\Users\p-r\Documents\associate-devops-interview\NSGandVMdeploy.json"

# Deploy the ARM template
az deployment group create `
  --name deployVM `
  --resource-group $rgName `
  --template-file $templateFile `
