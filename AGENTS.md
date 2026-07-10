# AGENTS — MoneyPrinterTurbo Multi-Agent Team

This document describes the coordinator and all specialist sub-agents used in Devin Desktop for this project.

## 1. Coordinator

**Agent:** `coordinator`  
**Role:** Senior engineer/architect that plans, delegates, integrates, and verifies — does not implement code.

**Responsibilities:**
- Understand user requests and repo context
- Produce `PLAN.md` or `tasks/<id>.md` before implementation
- Decompose work into atomic subtasks
- Delegate to specialist agents with clear scope and file ownership
- Isolate context (branches/worktrees, directories)
- Integrate results and run verification pipeline
- Enforce human review before merge

---

## 2. Core Implementation Agents

### 2.1 `python-developer`
**Role:** Python backend logic, FastAPI endpoints, services, tests, integrations.  
**Scope:** `app/`, `services/`, backend modules.

### 2.2 `api-specialist`
**Role:** FastAPI API design, routing, schemas, validation, OpenAPI.  
**Scope:** `app/controllers/v1/`, `app/models/schema.py`, `app/asgi.py`.

### 2.3 `streamlit-expert`
**Role:** Streamlit UI architecture, session state, caching, performance.  
**Scope:** `webui/`, `ui/`, `pages/`, Streamlit entrypoints.

### 2.4 `redis-engineer`
**Role:** Redis caching, serialization, connection resilience, TTLs.  
**Scope:** Redis client modules, cache layers, config.

### 2.5 `ollama-specialist`
**Role:** Ollama LLM integration, model lifecycle, streaming, structured outputs.  
**Scope:** `app/services/llm.py`, `VideoGrader`, Ollama config.

### 2.6 `devops-docker`
**Role:** Dockerfile, Docker Compose, deployment configs, container health.  
**Scope:** `Dockerfile*`, `docker-compose*.yml`, infra scripts.

---

## 3. Quality & Safety Agents

### 3.1 `python-reviewer`
**Role:** Rigorous Python code review (bugs, style, patterns, type safety).  
**Scope:** Python code only.

### 3.2 `swe-check`
**Role:** Bug detection for non-Python artifacts (Docker, Redis, API design, Streamlit, Ollama, config).  
**Scope:** Everything except pure Python.

### 3.3 `security-auditor`
**Role:** Security vulnerabilities, secret detection, input validation.  
**Scope:** Code, configs, dependencies.

### 3.4 `testing-guardian`
**Role:** Test coverage, test quality, mocking strategy.  
**Scope:** `tests/`, coverage, test infra.

### 3.5 `qa-ci-agent`
**Role:** CI workflows, linting, type checking, test orchestration, quality gates.  
**Scope:** `.github/workflows/`, lint/type-check configs, pre-commit.

---

## 4. Workflow & Docs Agents

### 4.1 `git-workflow`
**Role:** Git operations, branch management, commit validation, PR prep.  
**Scope:** Git state, branches, PRs.

### 4.2 `documentation-agent`
**Role:** README, API docs, architecture docs, migration guides, examples.  
**Scope:** `README.md`, `docs/`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `AGENTS.md`.

### 4.3 `architecture-reviewer`
**Role:** Repository architecture, module boundaries, dependency graph, conventions.  
**Scope:** Entire repo structure.

### 4.4 `playwright-testing`
**Role:** Playwright tests for WebUI, test creation, execution, debugging, maintenance.  
**Scope:** `tests/ui_tests.spec.ts`, `playwright.config.ts`, WebUI.

---

## 5. Coordination Rules

- Coordinator writes `PLAN.md` or `tasks/<id>.md` before implementation.
- Each sub-agent gets narrow scope and explicit file ownership.
- Parallel work uses branches/worktrees to avoid collisions.
- Verification pipeline: `swe-check` → tests → security → QA/CI → review.
- Human review is required before merging into `main`.