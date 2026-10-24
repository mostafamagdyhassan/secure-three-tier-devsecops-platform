#!/usr/bin/env bash

set -Eeuo pipefail
umask 077

BACKUP_DIR="${BACKUP_DIR:-backup/artifacts}"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP_FILE="${BACKUP_DIR}/database-${TIMESTAMP}.dump"
TEMP_FILE="${BACKUP_FILE}.tmp"

cleanup() {
    rm -f "$TEMP_FILE"
}
trap cleanup EXIT

if ! docker compose exec -T db pg_isready >/dev/null 2>&1; then
    echo "ERROR: PostgreSQL is not ready." >&2
    exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "Creating PostgreSQL backup..."

docker compose exec -T db sh -c \
    'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Fc' \
    > "$TEMP_FILE"

if [[ ! -s "$TEMP_FILE" ]]; then
    echo "ERROR: Backup file is empty." >&2
    exit 1
fi

docker compose exec -T db pg_restore --list \
    < "$TEMP_FILE" >/dev/null

mv "$TEMP_FILE" "$BACKUP_FILE"

echo "Backup completed: $BACKUP_FILE"
