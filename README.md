# Azure Terraform Linux VM Lab

## Project Overview

This project demonstrates Infrastructure as Code (IaC) using Terraform to deploy Azure resources.

### Resources Deployed

- Resource Group
- Virtual Network
- Subnets
- Network Security Group
- Security Rules
- Public IP Address
- Network Interface
- Ubuntu Linux Virtual Machine

### Technologies Used

- Microsoft Azure
- Terraform
- Linux (Ubuntu 24.04 LTS)
- SSH
- VS Code Remote SSH

### Terraform Commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

### Architecture

Resource Group
│
├── VNet
│ ├── Servers Subnet
│ └── Management Subnet
│
├── NSG
│ ├── SSH Rule (22)
│ └── RDP Rule (3389)
│
├── Public IP
├── Network Interface
└── Linux VM
