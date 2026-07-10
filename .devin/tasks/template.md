# Task: <task-id> — <Short Description>

## Task Metadata

- **task_id:** <task-id>
- **task_name:** <short description>
- **parent_task_id:** <coordinator-task-id or PLAN reference>
- **agent_type:** <profile-name, e.g., python-developer>
- **agent_name:** <human-readable name>
- **priority:** High | Medium | Low
- **risk_level:** Low | Medium | High
- **time_budget:** <e.g., 60–120 minutes>

## Context

- **Why:** <reason this task exists>
- **Related plan:** `PLAN.md` or `<plan-file>`
- **Relevant files:** <paths>

## Requirements

- **Deliverables:**
  - <code/config/tests/docs to produce>
- **Constraints:**
  - <performance, security, compatibility, etc.>

## Scope Boundaries

- **Allowed files/directories:**
  - <paths>
- **Do NOT modify:**
  - <paths/modules>

## Expected Output

- <description of expected changes, behavior, or artifacts>

## Verification Path

- **Primary checks:**
  - <unit/integration tests, manual checks>
- **Agents to run after completion:**
  - `swe-check`
  - `testing-guardian`
  - `security-auditor`
  - `qa-ci-agent`
  - `python-reviewer` (if Python)
  - `devops-docker` (if Docker)

## Logging Instructions

Sub-agent should log lifecycle:

```bash
python3 .devin/hooks/log_task.py --event started --task-id <task_id> --task-name "<task_name>" --agent-type <profile>
```

On completion:

```bash
python3 .devin/hooks/log_task.py --event completed --task-id <task_id> --progress 100 --details '{"result": "..."}'
# or --event failed with details explaining the failure
```