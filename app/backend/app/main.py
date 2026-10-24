from contextlib import asynccontextmanager

from fastapi import Depends, FastAPI, HTTPException, Response, status
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from app.database import Base, engine, get_db
from app.models import Task
from app.schemas import TaskCreate, TaskResponse, TaskUpdate


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Convenient for local development.
    # Production database changes should use migrations.
    Base.metadata.create_all(bind=engine)
    yield


app = FastAPI(
    title="Secure Three-Tier DevSecOps API",
    version="1.0.0",
    lifespan=lifespan,
)


@app.get("/health/live")
def liveness():
    return {"status": "alive"}


@app.get("/health/ready")
def readiness(db: Session = Depends(get_db)):
    try:
        db.execute(text("SELECT 1"))
        return {"status": "ready", "database": "connected"}
    except SQLAlchemyError:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database unavailable",
        )


@app.get("/tasks", response_model=list[TaskResponse])
def list_tasks(db: Session = Depends(get_db)):
    return db.query(Task).order_by(Task.id.desc()).all()


@app.post(
    "/tasks",
    response_model=TaskResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_task(payload: TaskCreate, db: Session = Depends(get_db)):
    task = Task(title=payload.title.strip())

    if not task.title:
        raise HTTPException(status_code=422, detail="Title cannot be empty")

    db.add(task)
    db.commit()
    db.refresh(task)
    return task


@app.patch("/tasks/{task_id}", response_model=TaskResponse)
def update_task(
    task_id: int,
    payload: TaskUpdate,
    db: Session = Depends(get_db),
):
    task = db.get(Task, task_id)

    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")

    changes = payload.model_dump(exclude_unset=True)

    if "title" in changes:
        title = changes["title"]
        if title is None or not title.strip():
            raise HTTPException(status_code=422, detail="Title cannot be empty")
        task.title = title.strip()

    if "completed" in changes:
        if changes["completed"] is None:
            raise HTTPException(status_code=422, detail="Completed must be true or false")
        task.completed = changes["completed"]

    db.commit()
    db.refresh(task)
    return task


@app.delete("/tasks/{task_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_task(task_id: int, db: Session = Depends(get_db)):
    task = db.get(Task, task_id)

    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")

    db.delete(task)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)
