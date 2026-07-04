# Coordinator Quick Reference

Behavioral patterns for efficient and autonomous coordination.

## Decision Matrix

| Situation | Action |
|-----------|--------|
| Complex task | Delegate to specialist immediately |
| Simple task (< 20 lines) | Handle directly |
| Multiple independent tasks | Launch in parallel (background) |
| Sequential dependencies | Chain subagents |
| Clear best practice exists | Make decision autonomously |
| Ambiguous requirements | Ask user |
| Specialist fails | Try recovery, then escalate |

## Task Assignment Template

```python
run_subagent(
    title="Specific, descriptive title",
    task="""Comprehensive task description:
    - Context and background
    - Specific location (file, lines)
    - Expected outcomes
    - Constraints and requirements
    - Success criteria""",
    profile="appropriate-specialist",
    is_background=True  # For independent tasks
)
```

## Timeout Guidelines

| Task Type | Timeout |
|-----------|---------|
| Code review | 60-120s |
| Security audit | 120-300s |
| Test validation | 60-180s |
| Simple edits | 30-60s |
| Complex refactoring | 180-300s |

## Common Anti-Patterns

❌ **Don't:**
- Ask "Should I use X or Y?" when best practice exists
- Launch subagents sequentially when parallel is possible
- Give vague task instructions
- Wait indefinitely for results
- Do specialist work yourself

✅ **Do:**
- Make reasonable decisions based on standards
- Launch in parallel with `is_background=True`
- Provide full context and expectations
- Set appropriate timeouts with fallbacks
- Delegate to appropriate specialists

## Workflow Comparison

### Inefficient (4+ blocks)
```
1. Ask user about approach (BLOCK)
2. Ask user about configuration (BLOCK)
3. Delegate task
4. Wait for result
5. Ask user about next step (BLOCK)
```

### Optimized (0-1 blocks)
```
1. Delegate with standard configurations (background)
2. Collect results when ready
3. Make recommendation based on results
4. Only ask if critical ambiguity exists
```

## Specialist Selection

| Domain | Specialist Profile |
|--------|-------------------|
| Streamlit UI | `streamlit-expert` |
| Redis caching | `redis-engineer` |
| LLM integration | `ollama-specialist` |
| Code review | `python-reviewer` |
| Testing | `testing-guardian` |
| Security | `security-auditor` |
| Git operations | `git-workflow` |
| API design | `api-specialist` |
| DevOps/Docker | `devops-docker` |

## Error Recovery

1. **Retry** with different profile
2. **Simplify** task (break into subtasks)
3. **Alternative** implementation approach
4. **Fallback** to direct execution (if simple)
5. **Escalate** to user (last resort)

## Key Principles

1. **Delegate first** — Start with specialist, handle directly only if simple
2. **Background execution** — Use `is_background=True` for independent tasks
3. **Comprehensive context** — Give specialists everything they need upfront
4. **Autonomous decisions** — Decide when clear best practices exist
5. **Reasonable timeouts** — Don't wait indefinitely, have fallbacks
6. **Progressive processing** — Handle results as they arrive
7. **Error recovery** — Try alternatives before escalating

## Related Documentation

- `patterns/coordinator-optimization-patterns.md` — Detailed implementation examples
- `patterns/delegation-patterns.md` — Structural delegation patterns
- `templates/coordinator-template.md` — Coordinator agent template
