# Terraform – AWS Infrastructure Information Management

## 1. Introduction

Terraform is an Infrastructure as Code (IaC) tool developed by HashiCorp. It allows infrastructure to be defined, configured and managed using configuration files.

In this project, Terraform is used to connect to AWS and retrieve information about an existing EC2 instance hosting the portfolio website.

The configuration demonstrates AWS provider setup, input variables, data sources and output values.

**Important:** This implementation reads information about existing infrastructure. It does not create, modify or destroy AWS resources.

## 2. Project Architecture

- Infrastructure provider: Amazon Web Services (AWS)
- IaC tool: Terraform
- AWS region: `us-east-1`
- AWS CLI profile: `portfolio-dev`
- Resource being inspected: Existing EC2 instance
- Configuration language: HashiCorp Configuration Language (HCL)

## 3. Project Structure

```text
terraform/
├── .terraform.lock.hcl
├── provider.tf
├── main.tf
└── README.md
```

### provider.tf

This file configures the Terraform AWS provider.

The project uses the HashiCorp AWS provider with version constraint `~> 5.0`.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "portfolio-dev"
}
```

The AWS CLI profile supplies the credentials used by Terraform.

### main.tf

This file defines an input variable, an AWS EC2 data source and output values.

**Input variable:**

```hcl
variable "instance_id" {
  description = "ID of the existing portfolio EC2 instance"
  type        = string
}
```

The instance ID is supplied through a Terraform variable value.

**EC2 data source:**

```hcl
data "aws_instance" "portfolio" {
  instance_id = var.instance_id
}
```

The `aws_instance` data source retrieves information about the specified existing EC2 instance.

It does not create a new EC2 instance.

**Output values:**

```hcl
output "portfolio_instance_id" {
  value = data.aws_instance.portfolio.id
}

output "portfolio_instance_type" {
  value = data.aws_instance.portfolio.instance_type
}

output "portfolio_public_ip" {
  value = data.aws_instance.portfolio.public_ip
}

output "portfolio_state" {
  value = data.aws_instance.portfolio.instance_state
}
```

These outputs display important information about the existing portfolio server.

## 4. AWS Configuration

Before executing Terraform, configure AWS CLI credentials using the `portfolio-dev` profile.

Verify the profile:

```bash
aws configure list --profile portfolio-dev
```

Verify AWS identity:

```bash
aws sts get-caller-identity --profile portfolio-dev
```

The configured IAM identity must have permission to describe the EC2 instance.

## 5. Terraform Execution Steps

Run the following commands from the Terraform directory.

### Step 1: Initialize Terraform

```bash
terraform init
```

Downloads the required AWS provider and initializes the working directory.

### Step 2: Format configuration files

```bash
terraform fmt
```

Formats Terraform configuration files consistently.

### Step 3: Validate configuration

```bash
terraform validate
```

Checks the Terraform configuration for syntax and configuration errors.

### Step 4: Provide the EC2 instance ID

```bash
terraform plan -var="instance_id=YOUR_EC2_INSTANCE_ID"
```

Replace `YOUR_EC2_INSTANCE_ID` with the actual existing EC2 instance ID.

### Step 5: Review the execution plan

```bash
terraform plan -var="instance_id=YOUR_EC2_INSTANCE_ID"
```

Review the plan to verify that Terraform is only reading the existing EC2 instance.

### Step 6: Apply the configuration

```bash
terraform apply -var="instance_id=YOUR_EC2_INSTANCE_ID"
```

Confirm the operation when prompted.

Because this configuration uses a data source rather than resource creation, it does not provision a new EC2 instance.

### Step 7: Display outputs

```bash
terraform output
```

Displays the retrieved EC2 information.

## 6. Terraform State and Dependency Lock File

### Terraform State

Terraform maintains a state file to track objects it manages or reads.

For this project, the state records the Terraform data source associated with the existing portfolio EC2 instance.

The state file may contain infrastructure information and should not be uploaded publicly.

### Dependency Lock File

The `.terraform.lock.hcl` file records the selected provider version and checksums.

It helps maintain consistent provider installations across executions.

## 7. Results

The Terraform configuration successfully retrieves information about the existing AWS portfolio EC2 instance.

The outputs include:

- EC2 instance ID
- Instance type
- Public IP address
- Instance running state

The configuration was formatted and validated, and the Terraform plan and apply operations were executed against the existing EC2 instance.

## 8. Limitations and Future Improvements

The current implementation focuses on reading existing infrastructure rather than provisioning it.

Possible future improvements include:

- Creating EC2 instances using Terraform resources.
- Configuring security groups.
- Managing networking and storage.
- Using remote state storage with appropriate access controls.
- Automating infrastructure provisioning and configuration.

## 9. Conclusion

This project demonstrates the use of Terraform to connect to AWS, retrieve existing EC2 infrastructure information, and display the results through output variables.

It provides practical experience with Infrastructure as Code concepts, AWS provider configuration, Terraform variables, data sources, state management and execution commands.
