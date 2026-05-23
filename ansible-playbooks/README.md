# Ansible Automation for Self-Hosted Sentry Deployment

This repository demonstrates infrastructure automation using Ansible to configure and deploy a Self-Hosted Sentry instance on a private Ubuntu EC2 instance.

The deployment architecture uses:
- One private EC2 instance for Sentry
- One management EC2 instance for Ansible execution
- SSH-based Ansible connectivity between servers

The playbooks automate Docker installation, package configuration, and server preparation required for running Self-Hosted Sentry.

---

## Architecture

```text
Ansible Control EC2 (Private)
      │
      │ SSH using private IP
      ▼
Sentry Server EC2 (Private)
```

---

## Repository Structure

```text
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

## Features

- **SSH-based Ansible automation**
- **Private EC2 server management**
- **Automated Docker installation**
- **Self-Hosted Sentry environment preparation**
- **Infrastructure automation using playbooks**
- **Secure deployment architecture using private networking**

---

## Prerequisites

### Ansible Control Server Requirements

Run the following commands on the Ansible control server to install Ansible:

```bash
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```

Verify the installation:

```bash
ansible --version
```

### AWS Infrastructure Requirements

#### Sentry Server
- **OS**: Ubuntu EC2 instance
- **Network**: Private subnet
- **System Specifications**:
  - Minimum 4 vCPU
  - Minimum 32 GB RAM
  - Minimum 20+ GB storage

#### Ansible Control Server
- **OS**: Ubuntu EC2 instance
- **Network**: Private subnet with SSH access enabled
- **Connectivity**: Private network access to the Sentry server

---

## Connectivity & Inventory Configuration

### Test SSH Connectivity

Test the connection from the Ansible Control Server to the Sentry Server:

```bash
ssh -i /home/ubuntu/.ssh/sentry-key.pem ubuntu@<private-ip>
```

### Configure Inventory

Verify or update the hosts file at `inventory/hosts.ini`:

```ini
[sentry]
10.0.0.22  # ← replace with your Sentry VM private IP

[sentry:vars]
ansible_user=ubuntu
ansible_connection=ssh
ansible_ssh_private_key_file=/home/ubuntu/.ssh/sentry-key.pem
ansible_python_interpreter=/usr/bin/python3
```

#### Explanation of Variables:
- `10.0.0.22` → Private IP of the Sentry server
- `ansible_user` → SSH login user
- `ansible_connection=ssh` → Use SSH for connectivity
- `ansible_ssh_private_key_file` → Path to the SSH private key
- `ansible_python_interpreter` → Python interpreter path on the target server

---

## Ansible Configuration

The implementation uses a custom `ansible.cfg` configuration file:

```ini
[defaults]
inventory = inventory/hosts.ini
remote_user = ubuntu
host_key_checking = False
deprecation_warnings = False
interpreter_python = auto_silent
vault_password_file = ~/.vault_pass

[ssh_connection]
ssh_args = -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
```

### Configuration Explanation

| Setting | Purpose |
|---|---|
| `inventory` | Location of the inventory file |
| `remote_user` | Ansible SSH login user |
| `host_key_checking=False` | Disables SSH host key verification (useful in auto-scaled environments) |
| `deprecation_warnings=False` | Hides Ansible deprecation warnings in stdout |
| `interpreter_python=auto_silent` | Automatically detects python interpreter silently |
| `vault_password_file` | Path to the file containing the vault password |

---

## Ansible Vault Configuration

Sensitive variables such as credentials are stored securely using Ansible Vault.

### Directory Structure

```text
group_vars/
└── all/
    └── secrets.yaml
```

### Example Encrypted File

```yaml
sentry_email: admin@example.com
sentry_password: MySecurePassword
```

### Vault Commands

- **Encrypt the secrets file**:
  ```bash
  ansible-vault encrypt group_vars/all/secrets.yaml
  ```

- **Edit the encrypted file**:
  ```bash
  ansible-vault edit group_vars/all/secrets.yaml
  ```

- **View the encrypted file**:
  ```bash
  ansible-vault view group_vars/all/secrets.yaml
  ```

### Vault Password File

Store the vault password locally:
```bash
~/ .vault_pass
```

Ensure you set secure file permissions on the password file:
```bash
chmod 600 ~/.vault_pass
```

---

## Verification & Execution

### Verify Connectivity

Run the Ansible ping module to verify connection to the host:

```bash
ansible all -i inventory/hosts.ini -m ping -v
```

Expected response status: **SUCCESS**

### Run Playbooks

Execute the playbooks in order:

```bash
# 1. Install Docker & Docker Compose
ansible-playbook -i inventory/hosts.ini playbooks/install-docker.yml -v

# 2. Create the Admin User
ansible-playbook -i inventory/hosts.ini playbooks/create-admin-user.yml -v

# 3. Setup and Install Sentry
ansible-playbook -i inventory/hosts.ini playbooks/sentry-install.yml -v
```

---

## Playbook Details

### Docker Installation
The `install-docker.yml` playbook handles:
- Apt package repository updating
- Docker GPG key and repository configuration
- Docker Engine & Docker Compose installation
- Docker service enablement and startup

### Self-Hosted Sentry Setup
The `sentry-install.yml` playbook prepares the Sentry server environment by:
- Organizing Docker-based Sentry deployment setup files
- Running dependency checks
- Orchestrating container initialization
- Referencing the [Official Sentry Self-Hosted Setup Documentation](https://develop.sentry.dev/self-hosted/)

---

## Security Design

This setup follows high-security architectural guidelines for private enterprise deployments:
- **Private Subnets**: Sentry server is fully deployed inside a private subnet.
- **Bastion/Control VM**: No public SSH or web access is permitted except through the Ansible control server.
- **Ansible Vault**: Credentials and secrets are encrypted in transit and at rest inside the codebase.
- **Key-based Auth**: Restricts all remote administration to SSH key-based authentication.

---

## Troubleshooting

### SSH Connection Issues
- Verify that your AWS Security Groups allow inbound port 22 traffic from the control server.
- Check route tables and VPC Peering/Transit Gateway config between the servers.

### Private Key Permissions
Ensure your key file has the correct local read-only permissions:
```bash
chmod 400 key.pem
```

### Docker Service Issues
Check the status of the Docker service on the target VM:
```bash
sudo systemctl status docker
```

---

## Author

- **Shubhangi Thakur** - *Cloud / DevOps Engineer*