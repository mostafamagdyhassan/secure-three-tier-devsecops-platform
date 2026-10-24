# Jenkins CI Pipeline

The Jenkins pipeline validates and tests the application, scans project
files and container images, and builds the frontend and backend images.

## Prerequisites

The Jenkins agent must have:

- Git
- Python 3
- Docker CLI and access to a Docker daemon
- Network access to retrieve required dependencies and scanner images

The pipeline's individual stages may require additional tools or credentials,
depending on their implementation.

## Configure the job

1. Push the project to GitHub.
2. Create a Jenkins Pipeline job.
3. Configure the Git repository as the source.
4. Use `jenkins/Jenkinsfile` as the pipeline script path.
5. Run the pipeline and inspect each stage's logs.

## Security considerations

Docker daemon access can grant extensive control over the agent host.
Use isolated, disposable agents for untrusted pull requests and avoid
exposing production credentials to untrusted builds.

Do not store secrets in the Jenkinsfile or source repository. Configure
required credentials through Jenkins credentials management.

## Troubleshooting

If a stage fails:

1. Identify the first failing stage.
2. Read the complete error output.
3. Reproduce the check locally where possible.
4. Fix the underlying issue rather than skipping the check.
5. Run the pipeline again.

A successful image build does not by itself prove that the application
is secure or ready for production.
