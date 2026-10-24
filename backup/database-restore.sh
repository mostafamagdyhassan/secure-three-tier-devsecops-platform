#!/usr/bin/env bash

set -Eeuo pipefail

BACKUP_FILE="${1:-}"

if [[ -z "$BACKUP_FILE" || ! -f "$BACKUP_FILE" ]]; then
    echo "Usage: $0 <backup-file>" >&2
    exit 1
fi

if [[ "${CONFIRM_RESTORE:-}" != "YES" ]]; then
    echo "ERROR: Restore replaces database objects and may cause data loss." >&2
    echo "Use only with an intentionally selected local or test database." >&2
    echo "After verifying the target, rerun with CONFIRM_RESTORE=YES." >&2
    exit 1
fi

if ! docker compose exec -T db pg_isready >/dev/null 2>&1; then
    echo "ERROR: PostgreSQL is not ready." >&2
    exit 1
fi

docker compose exec -T db pg_restore --list \
    < "$BACKUP_FILE" >/dev/null

echo "Restoring $BACKUP_FILE into the database configured by Docker Compose..."

docker compose exec -T db sh -c \
    'pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
      --clean --if-exists --no-owner --no-privileges --exit-on-error' \
    < "$BACKUP_FILE"

echo "Restore command completed successfully."
