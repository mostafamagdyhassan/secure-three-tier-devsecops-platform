"use strict";

const form = document.getElementById("task-form");
const titleInput = document.getElementById("task-title");
const addButton = document.getElementById("add-button");
const taskList = document.getElementById("task-list");
const taskCount = document.getElementById("task-count");
const message = document.getElementById("message");
const apiStatus = document.getElementById("api-status");
const statusDot = document.getElementById("status-dot");

async function apiRequest(path, options = {}) {
  const response = await fetch(`/api${path}`, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...options.headers,
    },
  });

  if (!response.ok) {
    throw new Error(`Request failed with status ${response.status}`);
  }

  if (response.status === 204) {
    return null;
  }

  return response.json();
}

function showMessage(text) {
  message.textContent = text;
}

function setApiStatus(online) {
  apiStatus.textContent = online
    ? "API connected"
    : "API unavailable — retry in a moment";

  statusDot.classList.toggle("online", online);
  statusDot.classList.toggle("offline", !online);
}

function renderTasks(tasks) {
  taskList.replaceChildren();

  taskCount.textContent =
    `${tasks.length} ${tasks.length === 1 ? "task" : "tasks"}`;

  if (tasks.length === 0) {
    const empty = document.createElement("li");
    empty.textContent = "No tasks yet. Add your first task above.";
    empty.className = "task-item";
    taskList.appendChild(empty);
    return;
  }

  for (const task of tasks) {
    const item = document.createElement("li");
    item.className = `task-item${task.completed ? " completed" : ""}`;

    const title = document.createElement("span");
    title.className = "task-title";
    title.textContent = task.title;

    const actions = document.createElement("div");
    actions.className = "task-actions";

    const toggle = document.createElement("button");
    toggle.type = "button";
    toggle.textContent = task.completed ? "Reopen" : "Complete";
    toggle.setAttribute(
      "aria-label",
      `${task.completed ? "Reopen" : "Complete"} ${task.title}`
    );
    toggle.addEventListener("click", async () => {
      try {
        await apiRequest(`/tasks/${task.id}`, {
          method: "PATCH",
          body: JSON.stringify({ completed: !task.completed }),
        });
        await loadTasks();
        showMessage("Task updated.");
      } catch {
        showMessage("Unable to update the task.");
      }
    });

    const remove = document.createElement("button");
    remove.type = "button";
    remove.className = "delete-button";
    remove.textContent = "Delete";
    remove.setAttribute("aria-label", `Delete ${task.title}`);
    remove.addEventListener("click", async () => {
      try {
        await apiRequest(`/tasks/${task.id}`, { method: "DELETE" });
        await loadTasks();
        showMessage("Task deleted.");
      } catch {
        showMessage("Unable to delete the task.");
      }
    });

    actions.append(toggle, remove);
    item.append(title, actions);
    taskList.appendChild(item);
  }
}

async function loadTasks() {
  try {
    const tasks = await apiRequest("/tasks");
    renderTasks(tasks);
    setApiStatus(true);
  } catch {
    setApiStatus(false);
    showMessage("Could not load tasks. Check that the backend is running.");
  }
}

form.addEventListener("submit", async (event) => {
  event.preventDefault();

  const title = titleInput.value.trim();

  if (!title) {
    showMessage("Enter a task title.");
    return;
  }

  addButton.disabled = true;

  try {
    await apiRequest("/tasks", {
      method: "POST",
      body: JSON.stringify({ title }),
    });

    titleInput.value = "";
    showMessage("Task created.");
    await loadTasks();
  } catch {
    showMessage("Unable to create the task.");
  } finally {
    addButton.disabled = false;
  }
});

loadTasks();
