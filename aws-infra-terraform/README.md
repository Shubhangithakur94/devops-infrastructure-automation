# Modular AWS Infrastructure using Terraform

This repository contains a modular and reusable Terraform based infrastructure setup for provisioning AWS resources following Infrastructure as Code (IaC) best practices.

The infrastructure is structured using reusable Terraform modules and environment specific configurations to support scalable and maintainable cloud infrastructure deployments.

---

# Overview

The infrastructure currently includes:

- VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- EC2 Instances

---

# Folder Structure

```text
.
├── env
│   └── dev
│       ├── compute
│       │   └── ec2-instance
│       ├── networking
│       │   ├── internet-gateway
│       │   ├── nat-gateway
│       │   ├── route-table
│       │   └── vpc-subnet
│       └── security
│           └── security-group
│
└── modules
    ├── compute
    │   └── ec2-instance
    ├── networking
    │   ├── internet-gateway
    │   ├── nat-gateway
    │   ├── route-table
    │   ├── subnet
    │   └── vpc
    └── security
        └── security-group

# Design Principles

This implementation follows the below Terraform best practices:

- Reusable modular architecture
- Environment specific configurations
- Remote Terraform state support
- Optional and configurable infrastructure parameters
- Separation of reusable modules and environment code
- Infrastructure scalability and maintainability

# Features

## Networking
- Custom VPC creation
- Public and private subnet support
- Internet Gateway configuration
- NAT Gateway setup for private subnet outbound connectivity
- Route table association management

## Security
- Modular Security Group creation
- Configurable ingress and egress rules

## Compute
- EC2 instance provisioning
- Optional public IP assignment


# Prerequisites

Ensure the following tools are installed:

Terraform >= 1.5.x
AWS CLI
Configured AWS credentials


# AWS Authentication

Configure AWS credentials using:

aws configure

or using environment variables:

export AWS_ACCESS_KEY_ID=<access-key>
export AWS_SECRET_ACCESS_KEY=<secret-key>
export AWS_DEFAULT_REGION=<region>


# Terraform Workflow

Navigate to the required environment directory.

Example:

cd env/dev/networking/vpc-subnet

Initialize Terraform:

terraform init

Validate configuration:

terraform validate

Preview changes:

terraform plan

Apply infrastructure:

terraform apply

Destroy infrastructure:

terraform destroy

# Remote Backend

Each environment folder contains its own backend configuration for Terraform remote state management.

Example backend file:

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "dev/vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}

# Module Reusability

The reusable modules are located under:

modules/

Environment specific implementations are located under:

env/dev/

This separation allows:

multi environment deployments
better maintainability
reusable infrastructure patterns

Author
Shubhangi Thakur
Cloud / DevOps Engineer