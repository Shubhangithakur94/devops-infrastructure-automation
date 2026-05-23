# Modular AWS Infrastructure using Terraform

This repository contains a modular and reusable Terraform-based AWS infrastructure setup following Infrastructure as Code (IaC) best practices.

The implementation is designed using reusable Terraform modules, environment-specific configurations, centralized labels, dynamic infrastructure definitions, and remote state integration to support scalable and maintainable cloud infrastructure deployments.

---

## Overview

The infrastructure currently supports:

- **VPC** (Virtual Private Cloud)
- **Public & Private Subnets**
- **Internet Gateway** (IGW)
- **NAT Gateway**
- **Route Tables** (Public and Private routes)
- **Security Groups**
- **EC2 Instances**

---

## Architecture Overview

This implementation follows a layered infrastructure approach:

1. **Networking Layer**: Sets up the core VPC, subnets, route tables, security groups, and gateways.
2. **Compute Layer**: Provisions EC2 instances and references resources from the Networking Layer.

Each layer maintains its own Terraform state file and consumes required outputs using Terraform Remote State (`terraform_remote_state`).

---

## Folder Structure

```text
.
├── README.md
├── env
│   └── dev
│       ├── 01-networking
│       │   ├── backend.tf
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── provider.tf
│       │   ├── terraform.tfvars
│       │   └── variables.tf
│       │
│       └── 02-compute
│           └── ec2-instance
│               ├── backend.tf
│               ├── data.tf
│               ├── main.tf
│               ├── terraform.tfvars
│               └── variables.tf
│
└── modules
    ├── compute
    │   └── ec2-instance
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    │
    ├── labels
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    │
    └── networking
        ├── route-table
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        │
        ├── security-group
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        │
        ├── subnet
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        │
        └── vpc
            ├── main.tf
            ├── outputs.tf
            └── variables.tf
```

---

## Design Principles

This implementation follows Terraform best practices including:

- **Reusable modular architecture**
- **Environment-specific infrastructure layers**
- **Centralized labels and tagging strategy**
- **Remote Terraform state integration**
- **Dynamic resource provisioning using `for_each`**
- **Separation of reusable modules and environment orchestration**
- **Scalable and maintainable infrastructure design**
- **Elimination of hardcoded resource IDs**
- **Logical resource referencing using keys**

---

## Prerequisites

Ensure the following tools are installed:

- **Terraform** (version `>= 1.5.x`)
- **AWS CLI**
- **Configured AWS credentials**

### AWS Authentication

Configure AWS credentials using the CLI:

```bash
aws configure
```

Or by exporting environment variables:

```bash
export AWS_ACCESS_KEY_ID="<access-key>"
export AWS_SECRET_ACCESS_KEY="<secret-key>"
export AWS_DEFAULT_REGION="<region>"
```

---

## Terraform Workflow

Navigate to the required environment layer. For example:

```bash
cd env/dev/01-networking
```

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```
2. **Validate configuration**:
   ```bash
   terraform validate
   ```
3. **Preview changes**:
   ```bash
   terraform plan
   ```
4. **Apply infrastructure**:
   ```bash
   terraform apply
   ```
5. **Destroy infrastructure** (when needed):
   ```bash
   terraform destroy
   ```

---

## Remote Backend Configuration

Each infrastructure layer maintains its own Terraform remote state configuration using an S3 backend.

Example configuration in `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket = "sentinel-dev-terraform-state-bucket"
    key    = "dev/networking/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

- Reusable modules are stored under: [`modules/`](file:///Users/shubhi/Working-dir/aws-infra-terraform/modules)
- Environment-specific orchestration is maintained under: [`env/dev/`](file:///Users/shubhi/Working-dir/aws-infra-terraform/env/dev)

This separation supports:
- **Multi-environment deployments**
- **Infrastructure reusability**
- **Better maintainability**
- **Scalable Terraform architecture**

---

## Author

- **Shubhangi Thakur** - *Cloud / DevOps Engineer*