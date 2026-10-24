-- Local development database initialization.
-- Do not use this file as a substitute for production migrations.

CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT tasks_title_not_blank CHECK (length(trim(title)) > 0)
);

CREATE INDEX IF NOT EXISTS idx_tasks_created_at
    ON tasks (created_at DESC);

COMMENT ON TABLE tasks IS
    'Task records for the Secure Three-Tier DevSecOps Platform';
