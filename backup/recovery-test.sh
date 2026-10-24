#!/usr/bin/env bash

set -Eeuo pipefail

BACKUP_FILE="${1:-}"

if [[ -z "$BACKUP_FILE" || ! -f "$BACKUP_FILE" ]]; then
    echo "Usage: $0 <backup-file>" >&2
    exit 1
fi

if ! docker compose exec -T db pg_isready >/dev/null 2>&1; then
    echo "ERROR: PostgreSQL is not ready." >&2
    exit 1
fi

TEST_DB="devsecops_recovery_test_$(date +%s)_$$"
CREATED_DB=0

cleanup() {
    if [[ "$CREATED_DB" -eq 1 ]]; then
        docker compose exec -T db sh -c \
            'dropdb --if-exists -U "$POSTGRES_USER" "$1"' \
            sh "$TEST_DB" >/dev/null 2>&1 || true
    fi
}
trap cleanup EXIT

echo "Creating temporary recovery database..."

docker compose exec -T db sh -c \
    'createdb -U "$POSTGRES_USER" "$1"' \
    sh "$TEST_DB"

CREATED_DB=1

echo "Restoring backup into temporary database..."

docker compose exec -T db sh -c \
    'pg_restore -U "$POSTGRES_USER" -d "$1" \
      --no-owner --no-privileges --exit-on-error' \
    sh "$TEST_DB" < "$BACKUP_FILE"

echo "Checking that the expected tasks table exists..."

RESULT="$(
    docker compose exec -T db sh -c \
        'psql -U "$POSTGRES_USER" -d "$1" -Atc \
        "SELECT to_regclass('\''public.tasks'\'') IS NOT NULL;"' \
        sh "$TEST_DB" | tr -d '\r'
)"

if [[ "$RESULT" != "t" ]]; then
    echo "ERROR: Recovery check failed; public.tasks was not found." >&2
    exit 1
fi

echo "SUCCESS: Backup restored and the tasks table exists."
