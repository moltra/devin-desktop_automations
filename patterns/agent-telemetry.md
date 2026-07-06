# Agent Telemetry & Accountability Pattern

This pattern defines a single, structured way for every subagent to report what it did, when it did it, and which permissions it needed. The goal is to make subagent work observable, auditable, and easy to aggregate by the coordinator or a parent agent.

## Output format

Every subagent must produce **one JSON telemetry record per task** that conforms to `agent-telemetry.json`. The record should be written to `.agent-logs/<agent_name>-<task_id>-<start_time>.json` when file writing is available, or included verbatim in the final response when it is not.

In addition to the JSON record, the agent should provide a brief human-readable summary of what it did and any blockers it hit.

## Required timestamps

- Record `start_time` **before** performing any work.
- Record `end_time` **after** the final handoff or verdict.
- Use ISO 8601 UTC format with millisecond precision, e.g. `2026-07-06T14:32:10.123Z`.
- If the agent cannot determine UTC, use the local system time with an explicit offset.

## Tool call log

For every tool call (`read`, `write`, `edit`, `exec`, `grep`, `glob`, `find_file_by_name`, `run_subagent`, `read_subagent`, `ask_user_question`, `mcp_call_tool`), append one entry to `tool_calls`:

| Field | Value |
|-------|-------|
| `timestamp` | ISO 8601 UTC when the call was made |
| `tool` | Tool name from the allowed list |
| `command` | Exact command (for `exec`) or file path (for `read`/`write`/`edit`); null otherwise |
| `purpose` | One sentence explaining why the call was needed |
| `status` | `success`, `failure`, `blocked`, or `pending_approval` |
| `tokens_input` | Input tokens if the runtime reports them; otherwise `null` |
| `tokens_output` | Output tokens if the runtime reports them; otherwise `null` |
| `tokens_total` | Total tokens if the runtime reports them; otherwise `null` |
| `permission_required` | `true` if the call required user approval |
| `permission_outcome` | `approved`, `denied`, `escalated`, or `not_required` |

### Token tracking note

Templates cannot count tokens themselves. If the runtime does not expose token usage, leave the token fields as `null` and record the command and output size so that cost can be estimated later. Never guess or invent token numbers.

## Permission tracking

Whenever a tool call is blocked, denied, or requires approval, create **both** a `tool_calls` entry and a `permission_requests` entry. The permission log is a separate view that makes it easy to spot missing permissions without scanning every tool call.

| Field | Value |
|-------|-------|
| `timestamp` | ISO 8601 UTC when the request occurred |
| `tool` | Tool or command that was blocked |
| `reason` | Why the agent needed the tool |
| `outcome` | `approved`, `denied`, `escalated`, or `pending` |

## Identity fields

- `agent_name`: Must match the `name` field in the template frontmatter.
- `task_id`: A short, unique identifier for this task instance. Use the one provided by the coordinator if available; otherwise generate a short UUID or timestamp-based ID.
- `parent_task_id`: If the task was delegated by a coordinator, include the coordinator's `task_id`.
- `task_summary`: A one-line description of the task goal.

## Final status

Use exactly one of these values for `final_status`:

- `complete`: the task finished successfully and produced a verdict or deliverable
- `blocked`: the task could not finish because a tool or permission was denied
- `failed`: the task finished but produced an error or failed its own validation
- `escalated`: the task deliberately handed off to the user for a decision

## Example

```json
{
  "agent_name": "security-auditor",
  "task_id": "sec-001",
  "parent_task_id": "coord-042",
  "task_summary": "Audit src/ for leaked secrets and unsafe dependencies",
  "start_time": "2026-07-06T14:32:10.000Z",
  "end_time": "2026-07-06T14:33:45.000Z",
  "tool_calls": [
    {
      "timestamp": "2026-07-06T14:32:15.000Z",
      "tool": "exec",
      "command": "bandit -r src/",
      "purpose": "Run static security scan on Python source",
      "status": "success",
      "tokens_input": null,
      "tokens_output": null,
      "tokens_total": null,
      "permission_required": false,
      "permission_outcome": "not_required"
    },
    {
      "timestamp": "2026-07-06T14:33:02.000Z",
      "tool": "exec",
      "command": "safety check",
      "purpose": "Check dependencies for known vulnerabilities",
      "status": "blocked",
      "tokens_input": null,
      "tokens_output": null,
      "tokens_total": null,
      "permission_required": true,
      "permission_outcome": "denied"
    }
  ],
  "permission_requests": [
    {
      "timestamp": "2026-07-06T14:33:02.000Z",
      "tool": "exec",
      "reason": "safety check requires network access to the PyPI advisory database",
      "outcome": "denied"
    }
  ],
  "final_status": "blocked",
  "notes": "Dependency safety scan could not run because safety check permission was denied."
}
```

## Coordinator aggregation

The coordinator should collect telemetry records from every subagent and synthesize:

- A table of subagent names, task IDs, start/end times, and final statuses.
- A list of denied or escalated permission requests.
- Recommended permission changes to reduce future blockers.
- The total number of tool calls, broken down by tool and status.

If the coordinator writes logs to disk, it should also emit a summary telemetry record of its own with a `subagent_leger` field containing the task IDs of all delegated tasks.
