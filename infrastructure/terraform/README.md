# Terraform Infrastructure

## Purpose

This directory contains Terraform configuration for the AWS foundation of the Secure Three-Tier DevSecOps Platform.

## Planned Infrastructure

- AWS VPC and subnet segmentation
- Internet gateway and public routing
- Private application and database subnets
- Amazon EKS for Kubernetes workloads
- Amazon ECR for container images
- Amazon RDS for PostgreSQL
- IAM roles and least-privilege permissions
- Encrypted storage and backup configuration
- Remote Terraform state

## Current Implementation

The initial Terraform configuration creates the VPC, internet gateway, public subnets, private application subnets, database subnets, public route table, and RDS subnet group.

The EKS cluster, RDS database, ECR repositories, IAM roles, and backup resources will be added in later stages.

## Prerequisites

- Terraform CLI compatible with the version constraint in `versions.tf`
- AWS CLI
- An AWS account
- AWS credentials configured through an approved method
- An appropriate AWS IAM identity with the required permissions

Do not commit AWS access keys or secret keys to this repository.

## Configuration

Copy the example variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Review the region, environment, subnet CIDRs, and resource settings before continuing.

The real `terraform.tfvars` file should remain untracked if it contains environment-specific or sensitive values.

## Validation

Run these commands from this directory:

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
terraform plan
```

The plan step requires provider initialization and valid AWS-related configuration. Review its output before applying anything.

## Remote State

Production and shared environments should use an encrypted S3 backend with versioning, tightly restricted access, and state locking supported by the chosen Terraform configuration.

Backend initialization must be configured before provisioning the main infrastructure. Do not commit Terraform state files.

## Cost and Safety

- Review estimated costs before applying.
- Avoid creating EKS clusters, NAT Gateways, load balancers, or RDS instances until the budget is understood.
- Use private database subnets.
- Do not expose PostgreSQL to the public internet.
- Run `terraform destroy` only after reviewing its impact and confirming that required data and backups are protected.

## Status

This infrastructure is under development. Validate the configuration and security posture before using it in a real environment.
