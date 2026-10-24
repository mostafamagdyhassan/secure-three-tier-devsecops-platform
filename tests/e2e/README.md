# End-to-End Tests

These checks validate the existing application through the frontend's
public HTTP interface.

## Prerequisites

- Docker Engine
- Docker Compose
- `curl`
- A local `.env` file with a development-only database password

## Start the application

From the repository root:

```bash
docker compose up --build -d
docker compose ps
