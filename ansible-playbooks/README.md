# Ansible Automation for Self-Hosted Sentry Deployment

## Overview

This implementation demonstrates infrastructure automation using Ansible to configure and deploy Self-Hosted Sentry on a private Ubuntu EC2 instance.

The deployment architecture uses:

- One private EC2 instance for Sentry
- One management EC2 instance for Ansible execution
- SSH-based Ansible connectivity between servers

The playbooks automate Docker installation, package configuration, and server preparation required for running Self-Hosted Sentry.

---

# Architecture

```text

Ansible Control EC2 (Private)
      │
      │ SSH using private IP
      ▼
Sentry Server EC2 (Private)
```
---

# Repository Structure

```bash
ansible/
├── inventory/
│   └── hosts.ini
├── playbooks/
│   ├── sentry-install.yml
│   ├── install-docker.yml
│   └── create-admin-user.yml
├── ansible.cfg
```

---

# Features

- SSH-based Ansible automation
- Private EC2 server management
- Automated Docker installation
- Self-Hosted Sentry environment preparation
- Infrastructure automation using playbooks
- Secure deployment architecture using private networking

---

# Prerequisites

## Ansible Control Server Requirements

# Install Ansible

Run the following commands on the Ansible control server:

```bash
sudo apt update

sudo apt install software-properties-common -y

sudo add-apt-repository --yes --update ppa:ansible/ansible

sudo apt install ansible -y
```

Verify installation:

```bash
ansible --version
```

---

# AWS Infrastructure Requirements

## Sentry Server

- Ubuntu EC2 instance
- Private subnet
- Minimum:
  - 4 vCPU
  - 32 GB RAM
  - 20+ GB storage

## Ansible Control Server

- Ubuntu EC2 instance
- Private subnet
- SSH access enabled
- Private network access to Sentry server

---

# Test SSH connectivity

```bash
ssh -i /home/ubuntu/.ssh/sentry-key.pem ubuntu@<private-ip>
```

---

# Configure Inventory

```bash

cat inventory/hosts.ini
```
Add the following configuration:

Explanation:

- `10.0.2.28` → Private IP of Sentry server
- `ansible_user` → SSH login user
- `ansible_connection=ssh` → Use SSH for connectivity
- `ansible_ssh_private_key_file` → SSH private key path
- `ansible_python_interpreter` → Python interpreter path on target server

---

## ansible.cfg

The implementation uses a custom Ansible configuration file

### Configuration Explanation

| Setting | Purpose |
|---|---|
| `inventory` | Inventory file location |
| `remote_user` | Ansible SSH user |
| `host_key_checking=False` | Disables SSH host key verification |
| `deprecation_warnings=False` | Hides Ansible deprecation warnings |
| `interpreter_python=auto_silent` | Automatically detects Python interpreter |
| `vault_password_file` | Stores vault password file path |

---

# Ansible Vault Configuration

Sensitive variables such as credentials are stored securely using Ansible Vault.

Directory structure:

```bash
group_vars/
└── all/
    └── secrets.yaml
```

Example encrypted file:

```yaml
sentry_email: admin@example.com
sentry_password: MySecurePassword
```

Encrypt secrets file:

```bash
ansible-vault encrypt group_vars/all/secrets.yaml
```

Edit encrypted file:

```bash
ansible-vault edit group_vars/all/secrets.yaml
```

View encrypted file:

```bash
ansible-vault view group_vars/all/secrets.yaml
```

---

# Vault Password File

Vault password stored locally:

```bash
~/.vault_pass
```

Set secure permissions:

```bash
chmod 600 ~/.vault_pass
```

---

# Verify Connectivity

Run:

```bash
ansible all -i inventory/hosts.ini -m ping -v
```

Expected output:

```bash
SUCCESS
```

---

# Run Playbook

Example:

```bash
ansible-playbook -i inventory/hosts.ini playbooks/install-docker.yml -v
ansible-playbook -i inventory/hosts.ini playbooks/create-admin-user.yml -v
ansible-playbook -i inventory/hosts.ini playbooks/sentry-install.yml -v
```

---

# Docker Installation

The playbook performs:

- apt package installation
- Docker repository configuration
- Docker Engine installation
- Docker Compose plugin installation
- Docker service enablement

---

# Self-Hosted Sentry Setup

The automation prepares the EC2 instance for:

- Docker-based Sentry deployment
- Dependency installation
- Service initialization
- Container orchestration using Docker Compose

Official Sentry self-hosted setup:

```bash
https://develop.sentry.dev/self-hosted/
```

---

# Security Design

This implementation uses a private deployment architecture:

- Sentry server deployed in private subnet
- No public access to application server
- SSH access routed through ansible control VM
- Controlled internal communication only
- Sensitive credentials stored using Ansible Vault
- Private infrastructure deployment
- No plaintext secrets inside playbooks
- SSH key-based authentication

---

# Troubleshooting

## SSH Connection Issues

Check:
- security groups
- subnet routing
- SSH key permissions

---

## Permission Issues

Ensure private key has correct permissions:

```bash
chmod 400 key.pem
```

---

## Docker Issues

Check Docker service:

```bash
sudo systemctl status docker
```
---

# Author
Shubhangi Thakur  
DevOps / Cloud Engineer