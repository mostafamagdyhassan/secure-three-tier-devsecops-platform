# Testing Strategy

## Objective

Validate application functionality, service integration, infrastructure configuration, and recovery procedures throughout the delivery lifecycle.

## Test Layers

### 1. Unit Tests

Test individual functions and application logic without requiring cloud infrastructure.

Examples:
- Task creation and validation.
- Task updates and deletion.
- Invalid input handling.
- Error handling for missing resources.

### 2. API Integration Tests

Validate API behavior and interactions with the database.

Examples:
- Create and retrieve a task.
- Update task completion status.
- Delete a task.
- Confirm database-unavailable behavior.

### 3. Container Tests

Verify that:
- Backend and frontend images build successfully.
- Containers run as non-root where applicable.
- Health checks behave as expected.
- Services communicate through the intended network.
- The database is not exposed publicly.

### 4. Infrastructure Tests

Validate Terraform formatting, configuration, and security controls before provisioning resources.

Examples:
- Terraform formatting and validation.
- Checkov security scanning.
- Review of public exposure and IAM permissions.
- Review of encryption and remote-state configuration.

### 5. Deployment Tests

Verify that:
- Kubernetes workloads become ready.
- Readiness and liveness probes work.
- Services route traffic correctly.
- Rollbacks can restore a previous healthy release.

### 6. Disaster Recovery Tests

Verify that:
- Backups complete successfully.
- Backup access is restricted.
- A backup can be restored into a separate target.
- Recovered data passes integrity checks.
- Actual recovery time is recorded.

## Local Backend Tests

From the repository root, create and activate a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r app/backend/requirements.txt
pytest -q app/backend/tests
```

## Test Results

The CI pipeline should retain test reports and make failures visible. Passing unit tests alone does not establish that the full cloud platform is production-ready.
