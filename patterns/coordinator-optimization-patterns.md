# Coordinator Optimization Patterns

This document describes behavioral patterns for maximizing coordinator efficiency and autonomy.

## Clear Task Delegation Protocol

### Use Case
When deciding whether to delegate work or handle it directly.

### Pattern
Delegate immediately for complex tasks; handle simple tasks directly.

### Implementation
```python
# ✅ CORRECT: Delegate immediately
run_subagent(
    title="Specific task",
    task="Clear, detailed instructions with context",
    profile="appropriate-specialist",
    is_background=True  # Run in background
)

# ❌ WRONG: Do work myself
read_file()
analyze_code()
make_changes()
```

### Benefits
- Faster task completion through specialization
- Reduced coordinator cognitive load
- Better resource utilization

## Comprehensive Task Instructions

### Use Case
When assigning work to specialist subagents.

### Pattern
Provide complete context, expected outcomes, and constraints.

### Implementation
```python
# ❌ Too Vague:
task = "Review the code and fix issues"

# ✅ Comprehensive:
task = """Please review the security changes in app/services/llm.py. Focus on:
1. HTTP timeout implementation
2. Error handling patterns
3. Input validation
4. Any new security vulnerabilities

Use the security-auditor profile. Run bandit scanning.
Provide specific file locations and line numbers for issues.
Return a detailed report with severity levels and fix recommendations."""
```

### Benefits
- Reduces back-and-forth communication
- Improves specialist accuracy
- Faster first-attempt success rate

## Background Execution for Independent Tasks

### Use Case
When multiple subtasks can execute simultaneously.

### Pattern
Launch all independent subagents in parallel, then collect results.

### Implementation
```python
# ❌ Sequential (Slow):
result1 = run_subagent(task1, profile="specialist1")  # Wait for completion
result2 = run_subagent(task2, profile="specialist2")  # Wait for completion
result3 = run_subagent(task3, profile="specialist3")  # Wait for completion

# ✅ Parallel (Fast):
# Launch all at once
agent1 = run_subagent(task1, profile="specialist1", is_background=True)
agent2 = run_subagent(task2, profile="specialist2", is_background=True)
agent3 = run_subagent(task3, profile="specialist3", is_background=True)

# Collect results when ready
result1 = read_subagent(agent1, block=True)
result2 = read_subagent(agent2, block=True)
result3 = read_subagent(agent3, block=True)
```

### Benefits
- Dramatically reduced overall completion time
- Better resource utilization
- Faster user feedback

## Autonomous Decision-Making

### Use Case
When making choices that have clear best practices.

### Pattern
Make reasonable decisions based on project conventions and industry standards.

### Implementation
```python
# ❌ Too Many Questions:
"Should I use ruff or black for linting?"
"Which timeout value should I use?"
"Should I create a new file or modify existing?"

# ✅ Make Reasonable Decisions:
# Use project standards
"Using ruff for linting (as per project convention)"
"Using 30s timeout for token requests, 120s for generation (industry standard)"
"Modify existing file to maintain project structure"
```

### Decision Framework

**Ask when:**
- Ambiguous requirements
- Multiple valid approaches with different trade-offs
- User preference matters (e.g., naming conventions)
- Potential destructive operations

**Decide when:**
- Clear best practices exist
- Project conventions are documented
- Industry standards apply
- Low-risk decisions

### Benefits
- Reduced blocking on user input
- Faster workflow progression
- Better user experience

## Progressive Enhancement Pattern

### Use Case
When attempting tasks that may require escalation.

### Pattern
Start with specialist delegation, enhance/escalate only if needed.

### Implementation
```python
# Step 1: Delegate to specialist
agent = run_subagent(
    title="Implement feature",
    task="Add new API endpoint with standard patterns",
    profile="api-specialist",
    is_background=True
)

# Step 2: Check result
result = read_subagent(agent, block=True)

# Step 3: Only escalate if specialist fails
if result.status == "needs_escalation":
    # Then ask user or try different approach
    ask_user_question("Specialist encountered issue. How should I proceed?")
```

### Benefits
- Faster first-attempt success
- Reduced unnecessary user interaction
- Graceful degradation

## Timeout Management

### Use Case
When waiting for subagent results.

### Pattern
Use reasonable timeouts with fallback strategies.

### Implementation
```python
# ❌ WRONG: Wait forever
result = read_subagent(agent, block=True, timeout=999999)

# ✅ CORRECT: Reasonable timeout with fallback
result = read_subagent(agent, block=True, timeout=120)
if result.status == "timeout":
    # Try alternative approach or escalate
    fallback_approach()
```

### Timeout Guidelines

| Task Type | Recommended Timeout |
|-----------|---------------------|
| Code review | 60-120s |
| Security audit | 120-300s |
| Test validation | 60-180s |
| Simple edits | 30-60s |
| Complex refactoring | 180-300s |

### Benefits
- Prevents indefinite blocking
- Enables error recovery
- Improves system responsiveness

## Context-Rich Task Assignment

### Use Case
When assigning tasks that require specific domain knowledge.

### Pattern
Provide full context including problem description, location, and expected fix.

### Implementation
```python
# ❌ Minimal Context:
task = "Fix the bug in the file"

# ✅ Full Context:
task = """Fix the Redis pagination bug in app/services/state.py.

Context:
- The bug causes empty task lists when all keys arrive in one SCAN batch
- The issue is in the get_all_tasks method around line 100-115
- The slice calculation uses post-increment total instead of pre-increment
- This is a critical bug affecting the task browser UI

Expected fix:
- Track prev_total before incrementing
- Use prev_total for slice offset calculation
- Add logging for debugging
- Test with single-batch and multi-batch scenarios

Use the redis-engineer profile for this task."""
```

### Benefits
- Higher specialist success rate
- Reduced iteration cycles
- More accurate results

## Result Synthesis Without Blocking

### Use Case
When processing results from multiple subagents.

### Pattern
Process results as they arrive rather than waiting for all.

### Implementation
```python
# Launch specialists
agents = [
    run_subagent(task1, profile="specialist1", is_background=True),
    run_subagent(task2, profile="specialist2", is_background=True),
]

# Process results as they complete
for agent in agents:
    result = read_subagent(agent, block=True, timeout=60)
    # Immediately process and synthesize
    synthesize_partial_result(result)
    # Don't wait for all to complete before starting synthesis
```

### Benefits
- Faster user feedback
- Progressive result display
- Better perceived performance

## Error Recovery Strategies

### Use Case
When subagent tasks fail.

### Pattern
Attempt recovery before escalating to user.

### Implementation
```python
# ❌ WRONG: Stop on first error
try:
    result = run_subagent(task, profile="specialist")
except Exception as e:
    ask_user("What should I do?")  # BLOCKING

# ✅ CORRECT: Try recovery
try:
    result = run_subagent(task, profile="specialist")
except Exception as e:
    # Try alternative approach
    logger.warning(f"Specialist failed: {e}, trying alternative")
    alternative_approach()
```

### Recovery Strategies

1. **Retry with different profile** (e.g., python-reviewer → security-auditor)
2. **Simplify task** (break into smaller subtasks)
3. **Alternative implementation** (different approach)
4. **Fallback to direct execution** (handle directly if simple enough)

### Benefits
- Reduced user interruption
- Higher task completion rate
- Better system resilience

## Pre-Flight Validation

### Use Case
Before delegating tasks to subagents.

### Pattern
Validate task appropriateness and complexity before delegation.

### Implementation
```python
# Check if task is appropriate for delegation
if is_simple_enough(task):
    # Do it myself (faster than delegation overhead)
    do_simple_task()
else:
    # Delegate to specialist
    run_subagent(task, profile="specialist", is_background=True)
```

### Validation Criteria

**Handle directly when:**
- Single file edit < 20 lines
- Simple string replacement
- Trivial refactoring
- Well-understood pattern

**Delegate when:**
- Multi-file changes
- Complex logic analysis
- Domain-specific expertise needed
- Security/performance implications

### Benefits
- Optimal resource allocation
- Reduced unnecessary delegation overhead
- Faster simple task completion

## Implementation Checklist

### ✅ Always Do
- Start with subagent delegation for complex tasks
- Use `is_background=True` for independent tasks
- Provide comprehensive task instructions
- Make reasonable decisions based on best practices
- Set appropriate timeouts
- Process results as they arrive
- Have fallback strategies

### ❌ Never Do
- Do specialist work myself unless necessary
- Block waiting for user instructions unnecessarily
- Ask questions that have clear best-practice answers
- Wait indefinitely for subagent results
- Launch subagents sequentially when parallel is possible
- Give vague or incomplete task instructions

## Example: Optimized Workflow

### Inefficient Approach
```
1. "Should I use python-reviewer or security-auditor?" (BLOCK)
2. User answers
3. "What timeout should I use?" (BLOCK)
4. User answers
5. Delegate task
6. Wait for result
7. "Should I commit the changes?" (BLOCK)
8. User answers
```

### Optimized Approach
```
1. Delegate to python-reviewer and security-auditor in parallel (background)
2. Use industry-standard timeouts (30s tokens, 120s generation)
3. Collect results when ready
4. Synthesize findings
5. Make recommendation based on results
6. Only ask if critical ambiguity exists
```

**Result:** Reduces blocking from 4+ user interactions to 0-1, dramatically improving efficiency.

## Customization Notes

When customizing these patterns for your project:

1. **Add project-specific timeout values** based on your task characteristics
2. **Include project-specific decision frameworks** for your domain
3. **Add project-specific recovery strategies** for your infrastructure
4. **Include project-specific validation criteria** for your codebase
5. **Add project-specific specialist profiles** for your domain needs
6. **Update escalation procedures** for your team structure
