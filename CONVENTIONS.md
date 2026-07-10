# CONVENTIONS — MoneyPrinterTurbo Project

This document defines naming, structure, and behavioral conventions for all code and agents.

## 1. Repository Structure

- **Backend:** `app/`, `services/`, `models/`
- **API:** `app/controllers/v1/`, `app/asgi.py`
- **UI:** `webui/`, `ui/`, `pages/`
- **Infra:** `Dockerfile*`, `docker-compose*.yml`, `config.toml`
- **Tests:** `tests/`, `ui_tests.spec.ts`, Playwright config
- **Docs:** `README.md`, `AGENTS.md`, `CONVENTIONS.md`, `ARCHITECTURE.md`, `docs/`
- **Tasks/Plans:** `PLAN.md`, `tasks/*.md`

## 2. Naming Conventions

- **Python modules:** `snake_case.py`
- **Classes:** `PascalCase`
- **Functions:** `snake_case`
- **Constants:** `UPPER_SNAKE_CASE`
- **Redis keys:** `namespace:entity:{id}` (e.g., `user:{id}`, `cache:search:{query}`)
- **Branches:** `feature/<short-description>`, `fix/<short-description>`
- **Tasks:** `tasks/<task-id>.md`

## 3. Error Handling

- Use domain-specific exceptions where possible.
- Avoid broad `except Exception:` unless re-raised or logged with context.
- Always include `request_id` or task identifiers in logs for traceability.

## 4. Logging

- Use structured logging with clear context (component, operation, identifiers).
- Do not log secrets or sensitive data.
- Use consistent log levels: `debug`, `info`, `warning`, `error`, `critical`.

## 5. Testing

- Use `pytest` for Python tests.
- Aim for:
  - Critical paths: ~100% coverage
  - Main features: ≥80%
- Use Arrange–Act–Assert structure.
- Name tests: `test_<function>_<scenario>`.

## 6. Streamlit

- Keep business logic out of UI files.
- Use `st.session_state` for state, not global variables.
- Use `@st.cache_data` / `@st.cache_resource` for expensive operations.

## 7. Redis

- Prefer `SCAN` over `KEYS` in production.
- Always set TTLs for cached keys.
- Use connection pools and proper timeouts.

## 8. Docker / DevOps

- Pin image versions (no `:latest`).
- Use health checks for services.
- Do not expose Redis or internal services publicly by default.
- Use `security_opt: no-new-privileges:true` where applicable.

## 9. Security

- No hardcoded secrets in code or compose files.
- Use environment variables or secret managers.
- Validate all external inputs (API, UI, file paths).

## 10. Agent Behavior

- Coordinator does not implement feature code.
- Sub-agents respect file ownership and scope.
- All agents follow this `CONVENTIONS.md` as baseline.