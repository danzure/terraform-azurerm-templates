# Azure Virtual Desktop Terraform Configuration

This repository contains Terraform code for deploying an Azure Virtual Desktop environment in Azure. It provisions the core AVD resources needed to get started, including a resource group, Azure Virtual Desktop workspace, host pool, application group, and session host virtual machines. The configuration also creates supporting infrastructure such as a virtual network, subnet, NSG, NAT gateway, optional Log Analytics workspace, and FSLogix storage for profile containers.

Resource names are generated dynamically using the convention `resourcetype-environment-application-location-instance` based on the values defined in the [varibles.tf](varibles.tf) file.

## Repository Structure

The files in this repository are organized as follows:

- **hosts.tf**: Configures the Windows session host virtual machines, NICs, OS disk settings, and VM extensions for host pool registration and domain join.

- **locals.tf**: Defines local values and naming helpers used throughout the configuration.

- **logs.tf**: Configures an optional Log Analytics Workspace for centralized monitoring and diagnostics.

- **main.tf**: Defines the main AVD resources, including the resource group, workspace, host pool, and desktop application group.

- **network.tf**: Deploys the virtual network, subnet, NSG, and NAT gateway used by the AVD environment.

- **outputs.tf**: Exposes useful deployment outputs such as resource IDs and other values for reference or further automation.

- **providers.tf**: Declares the Terraform providers required for the deployment.

- **README.md**: Provides an overview of the repository and explains the purpose of each configuration file.

- **storage.tf**: Creates the storage account and FSLogix share used for profile storage.

- **varibles.tf**: Contains the configurable input variables for location, workload, sizing, naming, tags, domain join settings, and other deployment options.

## Getting Started

To deploy the `Azure Virtual Desktop` environment using this Terraform configuration, follow these steps:

1. Install the Terraform CLI
2. Create a clone of this repository to your local machine
3. Login & configure your Azure credentials
4. Customize the `variables.tf` file to suit your own envrionment. 
5. Run `terraform init` to initialize the configuration.
6. Run `terraform plan` to review the planned changes. 
7. Run `terraform apply` to deploy the Azure Sandbox
8. Troubleshoot & perform any additional required configuration.

For more detailed information, please see the following: `https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli`, `https://developer.hashicorp.com/terraform/tutorials`, `https://learn.microsoft.com/en-us/azure/virtual-desktop/`

## Contributing

If you would like to contribute to this repository, please fork the repository and submit a pull request with your changes. I welcome any contributions that improve the functionality, security, and usability of the configuration.

## Authors
Daniel Powley

## License

This repository is licensed under the MIT License. See the `LICENSE` file for more information.