variable "aws_region" {
  description = "AWS region for project resources"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tags"
  type        = string
  default     = "secure-three-tier-devsecops"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR range for the project VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones used by the environment"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for public subnets"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR ranges for private application subnets"
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "database_subnet_cidrs" {
  description = "CIDR ranges for private database subnets"
  type        = list(string)
  default     = ["10.20.21.0/24", "10.20.22.0/24"]
}

variable "allowed_ssh_cidr" {
  description = "Optional trusted IPv4 CIDR for SSH; empty disables SSH ingress"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "Application database name"
  type        = string
  default     = "devsecops_db"
}

variable "db_username" {
  description = "Application database username"
  type        = string
  default     = "devsecops_app"
}

variable "db_instance_class" {
  description = "Amazon RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_backup_retention_days" {
  description = "Automated database backup retention in days"
  type        = number
  default     = 7

  validation {
    condition     = var.db_backup_retention_days >= 1 && var.db_backup_retention_days <= 35
    error_message = "Backup retention must be between 1 and 35 days."
  }
}

variable "eks_cluster_version" {
  description = "Kubernetes version for Amazon EKS; verify regional availability before deployment"
  type        = string
  default     = "1.32"
}
