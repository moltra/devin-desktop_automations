# Task Templates Quick Reference

Essential patterns for constructing effective task commands.

## Universal Template Structure

```
Please [action verb] [what] for [component].

**Context:** [Why this is needed]
**Requirements:** [Specific deliverables]
**Files:** [Scope boundaries]
**Success:** [Completion criteria]
**Constraints:** [Limitations]
**Priority:** [High/Medium/Low]
```

## Template Selection

| Task Type | Use Template |
|-----------|--------------|
| New feature/bug fix | Code Development |
| Documentation updates | Documentation |
| Debugging issues | Debugging |
| Performance problems | Performance |
| Security review | Security |
| Test creation | Testing |
| Git operations | Git/Repository |

## Command Quality Checklist

### ✅ DO
- Be specific about what you want
- Provide context about why it's needed
- Include constraints (what to avoid)
- Define success clearly
- Mention priority if time-sensitive

### ❌ DON'T
- Be vague ("fix the code")
- Skip context ("update docs")
- Over-constrain ("use exactly this approach")
- Forget success criteria ("make it better")
- Leave priority ambiguous for urgent tasks

## Example: Poor vs. Good Commands

### ❌ Poor
```
"Fix the task browser"
```

### ✅ Good
```
Please fix the task browser pagination issue where task lists appear empty when all keys arrive in a single Redis SCAN batch.

**Context:**
Redis pagination bug in app/services/state.py uses post-increment total instead of pre-increment for slice calculation.

**Requirements:**
- Fix slice calculation in get_all_tasks method
- Track prev_total before incrementing
- Add logging for debugging
- Test with single-batch and multi-batch scenarios

**Files:**
- app/services/state.py (lines 100-115)

**Success:**
- Pagination works for all batch sizes
- Task lists display properly
- No performance regression

**Priority:** High
```

## Coordinator Mode vs Direct Commands

### Use Coordinator Mode When
- Task involves multiple technical domains
- You need explicit specialist selection
- Task is ambiguous and needs analysis
- You want to monitor each step

### Use Direct Commands When
- Task is clear and well-defined
- Task falls within one domain
- You want autonomous completion
- Task is straightforward

## Quick Template: Bug Fix

```
Please fix [specific bug] in [component].

**Context:**
[What's happening vs. what should happen]
[Error messages/symptoms]

**Requirements:**
- Identify root cause
- Implement fix
- Add tests to prevent regression

**Files:**
- [Files where issue occurs]

**Success:**
- Issue is resolved
- Tests pass
- No regression

**Priority:** [High/Medium/Low]
```

## Quick Template: Feature Implementation

```
Please implement [feature] in [component].

**Context:**
[What needs to be built and why]

**Requirements:**
- Follow existing patterns in [directory]
- Use [specific frameworks/libraries]
- Handle [specific edge cases]

**Files:**
- [Files to modify/create]

**Success:**
- Code passes linting/type checking
- Tests pass
- Functionality works as expected

**Priority:** [High/Medium/Low]
```

## Priority Guidelines

| Priority | When to Use | Example |
|----------|-------------|---------|
| High | Blocking issues, security fixes, production bugs | "Pagination broken in production" |
| Medium | Feature requests, non-critical bugs | "Add new button to UI" |
| Low | Nice-to-have improvements, refactoring | "Improve code readability" |

## Key Elements by Task Type

| Element | Code | Debug | Docs | Performance | Security |
|---------|------|-------|------|-------------|----------|
| Context | ✓ | ✓ | ✓ | ✓ | ✓ |
| Requirements | ✓ | ✓ | ✓ | ✓ | ✓ |
| Files | ✓ | ✓ | ✓ | ✓ | ✓ |
| Success Criteria | ✓ | ✓ | ✓ | ✓ | ✓ |
| Constraints | ✓ | ✓ | ✓ | ✓ | ✓ |
| Priority | ✓ | ✓ | ✓ | ✓ | ✓ |
| Error Messages | - | ✓ | - | - | - |
| Performance Metrics | - | - | - | ✓ | - |
| Vulnerability Details | - | - | - | - | ✓ |

## Related Documentation

- `patterns/task-template-patterns.md` — Detailed template documentation with examples
- `patterns/coordinator-optimization-patterns.md` — Coordinator behavioral patterns
- `patterns/coordinator-quick-reference.md` — Quick reference for coordinator behavior
