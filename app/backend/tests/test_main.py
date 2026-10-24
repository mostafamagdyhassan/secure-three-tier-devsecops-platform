import os
from pathlib import Path

os.environ["DATABASE_URL"] = "sqlite:///./test_tasks.db"

from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.database import Base, get_db
from app.main import app

test_engine = create_engine(
    "sqlite://",
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)

TestingSessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=test_engine,
)

Base.metadata.create_all(bind=test_engine)


def override_get_db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db] = override_get_db


def setup_function():
    Base.metadata.drop_all(bind=test_engine)
    Base.metadata.create_all(bind=test_engine)


client = TestClient(app)


def test_liveness():
    response = client.get("/health/live")
    assert response.status_code == 200
    assert response.json()["status"] == "alive"


def test_create_and_list_task():
    created = client.post("/tasks", json={"title": "Build CI pipeline"})
    assert created.status_code == 201
    assert created.json()["title"] == "Build CI pipeline"
    assert created.json()["completed"] is False

    listed = client.get("/tasks")
    assert listed.status_code == 200
    assert len(listed.json()) == 1


def test_reject_empty_title():
    response = client.post("/tasks", json={"title": "   "})
    assert response.status_code == 422


def test_update_task():
    created = client.post("/tasks", json={"title": "Initial task"})
    task_id = created.json()["id"]

    updated = client.patch(
        f"/tasks/{task_id}",
        json={"completed": True},
    )

    assert updated.status_code == 200
    assert updated.json()["completed"] is True


def test_delete_task():
    created = client.post("/tasks", json={"title": "Delete me"})
    task_id = created.json()["id"]

    deleted = client.delete(f"/tasks/{task_id}")
    assert deleted.status_code == 204

    missing = client.get("/tasks")
    assert missing.status_code == 200
    assert missing.json() == []


def test_missing_task_returns_404():
    response = client.patch("/tasks/99999", json={"completed": True})
    assert response.status_code == 404
