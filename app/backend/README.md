# Backend API

The backend is a FastAPI application using SQLAlchemy and PostgreSQL.

## Requirements

- Python 3.12
- PostgreSQL for local or deployed application use
- Dependencies listed in `requirements.txt`

## Run locally

From the repository root:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r app/backend/requirements.txt

export DATABASE_URL="postgresql+psycopg://devsecops_user:your-local-password@localhost:5432/devsecops_db"

uvicorn app.main:app --app-dir app/backend --reload
