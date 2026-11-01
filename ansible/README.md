# Ansible – Portfolio Server Configuration and Deployment

## 1. Introduction

Ansible is an automation tool used to configure servers, install dependencies, manage services, and deploy applications.

In this project, Ansible is used from a VMware Ubuntu machine (controller) to connect to an existing AWS EC2 Ubuntu instance (managed node) through SSH.

The objective is to automate the deployment and management of the portfolio website using Docker.

## 2. Project Architecture

- **Ansible Controller:** VMware Ubuntu
- **Managed Node:** Existing AWS EC2 Ubuntu instance
- **Connection:** SSH using a private key
- **Container Platform:** Docker
- **Docker Image:** `maneesha0805/portfolio:v1`
- **Container Name:** `my-portfolio`
- **Container Port Mapping:** `127.0.0.1:8080:80`
- **Web Server:** Caddy reverse proxy with HTTPS

### Workflow

1. Ansible runs on VMware Ubuntu.
2. Ansible connects to AWS EC2 using SSH.
3. Ansible checks the Docker installation.
4. Ansible pulls the portfolio image from Docker Hub.
5. Ansible ensures the portfolio container is running.
6. The portfolio is accessed through the configured public HTTPS domain.

## 3. Installation and Configuration

### Install Ansible

Install Ansible on the VMware Ubuntu controller:

```bash
sudo apt update
sudo apt install ansible -y
```

Verify:

```bash
ansible --version
```

### Configure SSH Access

The AWS EC2 private key is stored securely on the controller.

Set restrictive permissions:

```bash
chmod 400 ~/.ssh/portfolio.pem
```

Test the SSH connection:

```bash
ssh -i ~/.ssh/portfolio.pem ubuntu@EC2_PUBLIC_IP
```

Replace `EC2_PUBLIC_IP` with the current public IP address of the EC2 instance.

## 4. Ansible Inventory

The inventory identifies the remote server managed by Ansible.

Example `inventory.ini`:

```ini
[portfolio]
aws-portfolio ansible_host=EC2_PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=/home/USERNAME/.ssh/portfolio.pem
```

Replace the example values with the actual EC2 IP and controller username.

The real `inventory.ini` is excluded from Git because it contains environment-specific connection details.

Test connectivity:

```bash
ansible -i ansible/inventory.ini portfolio -m ping
```

A successful connection returns:

```text
"ping": "pong"
```

## 5. Playbooks Implemented

### first-playbook.yml

- Runs locally on the Ansible controller.
- Collects operating system information.
- Displays a successful automation message.

Execute:

```bash
ansible-playbook ansible/first-playbook.yml
```

### check-services.yml

- Checks the Docker service.
- Checks the Caddy service.
- Displays their service statuses.

Execute:

```bash
ansible-playbook ansible/check-services.yml
```

### portfolio-health-check.yml

- Performs a local portfolio server health check.
- Checks Docker and Caddy service states.
- Displays a health report.

Execute:

```bash
ansible-playbook ansible/portfolio-health-check.yml
```

### deploy-portfolio.yml

This is the remote deployment playbook.

It performs the following tasks:

1. Connects to the EC2 instance.
2. Checks the Docker version.
3. Displays Docker version information.
4. Pulls `maneesha0805/portfolio:v1` from Docker Hub.
5. Ensures that the `my-portfolio` container is running.
6. Configures the container to restart automatically unless stopped.

Execute:

```bash
ansible-playbook -i ansible/inventory.ini ansible/deploy-portfolio.yml
```

## 6. Dependencies

The following components are required:

- Ansible installed on the VMware Ubuntu controller.
- SSH access to the AWS EC2 instance.
- Docker installed on the EC2 instance.
- Python Docker SDK installed on the EC2 instance.
- `community.docker` Ansible collection installed on the controller.

Install the collection:

```bash
ansible-galaxy collection install community.docker
```

Install the Python Docker SDK remotely:

```bash
ansible -i ansible/inventory.ini portfolio -b -m apt -a "name=python3-docker state=present update_cache=yes"
```

## 7. Deployment Verification

Check the remote Docker container:

```bash
ansible -i ansible/inventory.ini portfolio -b -m command -a "docker ps"
```

Expected container details:

- Image: `maneesha0805/portfolio:v1`
- Name: `my-portfolio`
- Status: Running
- Port mapping: `127.0.0.1:8080->80/tcp`

The public portfolio website can be accessed using the configured HTTPS domain:

`https://maneeshareddy.duckdns.org`

## 8. Security

- SSH private keys must never be uploaded to GitHub.
- The real inventory file is excluded through `.gitignore`.
- The SSH private key is stored on the controller.
- SSH is used for communication between the controller and managed node.
- Privileged remote tasks use Ansible privilege escalation (`become: true`).

## 9. Result

Ansible successfully connected from VMware Ubuntu to the existing AWS EC2 instance, verified Docker, pulled the portfolio image, and ensured that the portfolio container was running.

The deployment playbook completed with zero failed and zero unreachable tasks.

This demonstrates remote server automation and application deployment using Ansible.
