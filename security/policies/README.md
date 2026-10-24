# Security Policies

This directory documents the security requirements for the project.

## Container security

- Run application containers as non-root users.
- Do not bake credentials into images.
- Scan images for known vulnerabilities.
- Prefer pinned image versions and immutable release tags.
- Remove unnecessary Linux capabilities.

## Infrastructure security

- Keep Terraform state and secrets out of Git.
- Review security group ingress rules.
- Encrypt persistent data where supported.
- Review IAM permissions for least privilege.
- Run Checkov against Terraform changes.

## Kubernetes security

- Use the Restricted Pod Security Standard where compatible.
- Disable service account token mounting when not required.
- Apply network policies only after required traffic is explicitly allowed.
- Define resource requests and limits.
- Scan Kubernetes manifests before deployment.

## Exceptions

Document each accepted security exception with:

- The affected resource or check
- The reason for the exception
- The risk and compensating control
- The owner responsible for reviewing it
- An expiry or review date

Do not silently suppress security findings. Every exception should be reviewed
before release.
