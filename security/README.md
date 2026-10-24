# Security and Shift-Left Strategy

## Objective

Integrate security checks throughout the software delivery lifecycle so that vulnerabilities, leaked secrets, insecure infrastructure, and vulnerable container images are detected before deployment.

## Security Controls

| Stage | Tool | Purpose |
|---|---|---|
| Source control | Gitleaks | Detect accidentally committed secrets |
| Code quality | SonarQube | Identify code-quality issues and supported security findings |
| Python dependencies | pip-audit | Check dependencies against known vulnerability advisories |
| Infrastructure as Code | Checkov | Detect insecure Terraform configuration |
| Container images | Trivy | Scan images for known vulnerabilities |
| Kubernetes | Kubernetes security controls | Restrict privileges and network access |
| Image integrity | Cosign | Verify signed images when signing is implemented |

## Pipeline Policy

1. Run automated tests before packaging.
2. Scan source code and dependencies.
3. Scan Terraform before provisioning cloud resources.
4. Build images only after earlier checks pass.
5. Scan images before publishing or deploying them.
6. Require human review for exceptions to security gates.
7. Record findings and remediation decisions.

## Secrets Management

- Never commit `.env`, cloud credentials, private keys, or production passwords.
- Use Jenkins Credentials for CI/CD secrets.
- Use AWS IAM roles and short-lived credentials where possible.
- Use AWS Secrets Manager or another approved secret store for production secrets.
- Rotate exposed credentials immediately.

## Container Security

- Use minimal base images and pin dependencies.
- Run application processes as non-root.
- Avoid privileged containers.
- Use read-only filesystems where compatible.
- Set CPU and memory requests and limits.
- Scan images and rebuild when relevant security fixes are available.

## Infrastructure Security

- Keep databases private.
- Apply least-privilege IAM permissions.
- Encrypt data at rest and in transit.
- Restrict inbound security-group rules.
- Protect Terraform state and its backend.
- Enable cloud audit logging and alerting.

## Vulnerability Response

1. Identify the affected component.
2. Assess severity, exposure, and exploitability.
3. Upgrade or remediate the vulnerable component.
4. Rerun relevant tests and scans.
5. Document any accepted residual risk.
6. Verify the fix in the resulting artifact.

## Current Implementation Status

This document describes the intended controls. A control must not be described as operational until its pipeline integration and expected behavior have been tested successfully.
