# Secure Three-Tier DevSecOps Platform

A production-inspired DevSecOps portfolio project demonstrating infrastructure as code, automated CI/CD, containerization, Kubernetes, shift-left security, monitoring, and disaster recovery on AWS.

## Project Goals

- Provision cloud infrastructure using Terraform.
- Build and test application code automatically with Jenkins.
- Containerize the frontend and backend using Docker.
- Deploy workloads to Kubernetes using Helm.
- Integrate automated security checks into the CI/CD pipeline.
- Protect application data with encrypted backups and tested recovery procedures.
- Monitor application health, performance, and infrastructure.
- Apply least-privilege access, network isolation, and secure secret management.

## Architecture

```text
Developer
   |
   v
GitHub Repository
   |
   v
Jenkins CI/CD Pipeline
   |
   +--> Unit and Integration Tests
   +--> Code Quality Checks
   +--> Dependency Vulnerability Scanning
   +--> Secret Detection
   +--> Terraform Security Scanning
   +--> Container Image Scanning
   |
   v
Amazon ECR
   |
   v
Amazon EKS (Kubernetes)
   |
   +--> Frontend: NGINX
   +--> Backend: FastAPI
   |
   v
Private Amazon RDS PostgreSQL

Observability:
Prometheus + Grafana + Alertmanager

Infrastructure:
Terraform + AWS VPC + IAM + EKS + ECR + RDS

Resilience:
Automated Backups + Recovery Tests + Documented RPO/RTO
