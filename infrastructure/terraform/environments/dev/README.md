# Development Environment

## Purpose

This directory documents the intended development environment for the project.

The goal is to keep development resources separate from staging and production resources.

## Environment Principles

- Use a separate Terraform state for this environment.
- Apply consistent resource tags.
- Use development-specific resource sizing.
- Keep database access private.
- Avoid permanent public access to administrative services.
- Use temporary, short-lived credentials.
- Set budget alerts before deploying billable resources.

## Planned Workflow

1. Review Terraform changes.
2. Run formatting and validation.
3. Run Checkov or an equivalent infrastructure security scanner.
4. Review the Terraform plan.
5. Obtain approval when required.
6. Apply changes through the approved deployment workflow.
7. Verify resource health and costs.
8. Record the result.

## Status

This README documents the intended workflow. A dedicated development backend, environment-specific deployment pipeline, and deployed AWS resources still need to be implemented and verified.
