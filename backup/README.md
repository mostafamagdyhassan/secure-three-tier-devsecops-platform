# Backup and Disaster Recovery

## Objective

Protect application data against accidental deletion, infrastructure failure, and operational mistakes. Recovery must be tested rather than assumed.

## Backup Strategy

### Database

For the planned Amazon RDS PostgreSQL deployment:

- Enable automated backups with an appropriate retention period.
- Enable point-in-time recovery where supported.
- Encrypt backups.
- Restrict restore and deletion permissions.
- Consider a separate account or protected backup vault for stronger isolation.
- Define retention requirements before production deployment.

### Object Storage

For application-generated backup artifacts:

- Use a private S3 bucket.
- Enable server-side encryption.
- Block public access.
- Apply least-privilege IAM policies.
- Configure lifecycle and retention policies.
- Consider versioning and S3 Object Lock where appropriate.

## Recovery Objectives

The following are initial project targets, not measured guarantees:

| Metric | Initial Target |
|---|---|
| Recovery Point Objective (RPO) | 15 minutes |
| Recovery Time Objective (RTO) | 60 minutes |

Actual results depend on the AWS configuration, database size, backup frequency, and recovery procedure. Record measured values during restore exercises.

## Recovery Procedure

1. Identify the incident and select a known-good recovery point.
2. Obtain approved recovery authorization.
3. Restore into an isolated database or environment.
4. Verify schema and data integrity.
5. Run application and connectivity tests.
6. Confirm security controls and permissions.
7. Record the recovery duration and recovered data point.
8. Document the result and corrective actions.

## Restore-Test Evidence

Record the following for each exercise:

- Exercise date and operator.
- Backup identifier and timestamp.
- Source and recovery target.
- Restore start and finish times.
- Data-integrity checks.
- Measured RPO and RTO.
- Result, issues, and follow-up actions.

## Security Requirements

- Never store database passwords in backup scripts or Git.
- Encrypt backup data in transit and at rest.
- Prevent ordinary application identities from deleting backups.
- Monitor backup failures.
- Periodically test recovery from a separate environment.

## Current Status

This document defines the recovery plan. Automated backup configuration, restore automation, and measured recovery results must be implemented and verified separately.
