# Database

The project uses PostgreSQL for persistent task storage.

## Initialization

The `init.sql` file defines the initial database schema and index.

Docker Compose mounts this file into PostgreSQL's initialization directory.
PostgreSQL runs initialization scripts only when creating a new database
data directory.

If the named database volume already exists, changing `init.sql` will not
automatically apply those changes to the existing database.

## Schema consistency

The backend defines its Task model in:

`app/backend/app/models.py`

Keep the SQL schema and SQLAlchemy model consistent when changing fields,
types, defaults, or constraints.

The application currently uses SQLAlchemy `create_all` during startup.
This is suitable for the current project baseline, but it does not manage
schema changes to existing tables as a database migration system would.

## Local data

The Compose database uses a named volume called `postgres_data`.

Stopping containers does not delete this volume.

Do not delete the volume unless you intentionally want to remove the
local database contents.

## Security

- Never commit real database passwords.
- Do not expose PostgreSQL publicly.
- Use a separate database and credentials for production.
- Back up production data before schema changes.
