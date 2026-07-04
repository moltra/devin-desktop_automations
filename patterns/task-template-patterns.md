# Task Template Patterns

This document describes patterns for constructing effective task commands that maximize coordinator efficiency and accuracy.

## Universal Task Template

### Structure
```
Please [action verb] [what needs to be done] for [project/component].

**Context:**
[Background information about why this task is needed, any relevant history]

**Requirements:**
- [Specific requirement 1]
- [Specific requirement 2]
- [Specific requirement 3]

**Files/Components Involved:**
- [File/directory 1]
- [File/directory 2]

**Success Criteria:**
- [How you'll know the task is complete]
- [What the expected outcome should be]

**Constraints/Preferences:**
- [Any limitations or preferences]
- [Things to avoid]
- [Specific approaches to use or avoid]

**Priority:** [High/Medium/Low]
```

### Template Elements

| Element | Purpose | Example |
|---------|---------|---------|
| Action verb | Clear directive | "implement", "fix", "refactor" |
| Context | Background and motivation | "Pagination fails when Redis returns single batch" |
| Requirements | Specific deliverables | "Use existing patterns", "Include error handling" |
| Files involved | Scope boundaries | "app/services/state.py", "tests/test_state.py" |
| Success criteria | Completion definition | "Tests pass", "Performance improves by 50%" |
| Constraints | Limitations and guardrails | "Don't break existing functionality" |
| Priority | Urgency indication | "High" for blocking issues |

## Domain-Specific Templates

### Code Development Template

```
Please [implement/fix/refactor] [feature/bug] in [component].

**Context:**
[What needs to be done and why]

**Requirements:**
- Follow existing code patterns in [directory]
- Use [specific frameworks/libraries]
- Include [specific functionality]
- Handle [specific edge cases]

**Files Involved:**
- [Specific files to modify]
- [Related files to consider]

**Success Criteria:**
- Code passes linting (ruff, black, isort)
- Code passes type checking (mypy)
- Tests pass if applicable
- Functionality works as expected

**Constraints:**
- Don't break existing functionality
- Follow project coding standards
- Add appropriate error handling

**Priority:** [High/Medium/Low]
```

### Documentation Template

```
Please update [documentation file] to reflect [changes].

**Context:**
[What changed that needs documentation]

**Requirements:**
- Update [specific sections]
- Add [new information]
- Remove [outdated information]
- Maintain existing documentation style

**Files Involved:**
- [Documentation files to update]
- [Source files to reference]

**Success Criteria:**
- Documentation is accurate and up-to-date
- New features are properly explained
- Configuration examples are correct
- User-facing language is clear

**Constraints:**
- Keep user-friendly tone
- Include code examples where helpful
- Reference related documentation
- Don't include project-specific secrets

**Priority:** [High/Medium/Low]
```

### Debugging Template

```
Please investigate and fix [issue/bug] in [component].

**Context:**
[What is happening vs. what should happen]
[Error messages or symptoms]
[When this started occurring]

**Requirements:**
- Identify root cause
- Implement fix
- Add tests to prevent regression
- Document the issue and solution

**Files Involved:**
- [Files where issue occurs]
- [Related configuration files]
- [Test files]

**Success Criteria:**
- Issue is resolved
- Fix doesn't break other functionality
- Tests pass
- Issue is documented for future reference

**Constraints:**
- Don't change unrelated code
- Add logging for debugging if needed
- Consider edge cases

**Priority:** [High/Medium/Low]
```

### Performance Template

```
Please optimize [component/function] for better performance.

**Context:**
[Current performance issues]
[Performance goals or requirements]
[When performance problems occur]

**Requirements:**
- Profile to identify bottlenecks
- Implement optimizations
- Measure performance improvements
- Ensure optimizations don't break functionality

**Files Involved:**
- [Files to optimize]
- [Test files for performance validation]

**Success Criteria:**
- Performance improves by [specific metric]
- Functionality remains intact
- Code remains maintainable
- Performance is measurable

**Constraints:**
- Don't sacrifice code clarity for micro-optimizations
- Consider trade-offs (memory vs. speed)
- Add performance monitoring if helpful

**Priority:** [High/Medium/Low]
```

### Testing Template

```
Please [create/update] tests for [component/functionality].

**Context:**
[What needs testing]
[Why tests are needed]
[Current test coverage]

**Requirements:**
- Test [specific scenarios]
- Include edge cases
- Mock external dependencies
- Achieve [specific coverage percentage]

**Files Involved:**
- [Source files to test]
- [Test files to create/update]
- [Test fixtures to use]

**Success Criteria:**
- Tests pass consistently
- Tests cover main functionality
- Tests handle edge cases
- Tests are maintainable

**Constraints:**
- Use existing test patterns
- Keep tests fast
- Avoid brittle tests
- Use appropriate test data

**Priority:** [High/Medium/Low]
```

### Security Template

```
Please review and fix security issues in [component].

**Context:**
[Security concerns or vulnerabilities]
[Security requirements or compliance]
[When security review is needed]

**Requirements:**
- Identify security vulnerabilities
- Implement security fixes
- Add security tests if needed
- Document security decisions

**Files Involved:**
- [Files with security concerns]
- [Authentication/authorization files]
- [Configuration files]

**Success Criteria:**
- Vulnerabilities are addressed
- Security best practices are followed
- No new security issues introduced
- Security changes are documented

**Constraints:**
- Don't over-engineer security
- Consider user experience impact
- Follow security compliance requirements
- Test security fixes

**Priority:** [High/Medium/Low]
```

### Git/Repository Template

```
Please [commit/merge/branch] [changes] with [specific requirements].

**Context:**
[What changes need to be committed]
[Branch or merge strategy]
[Any git workflow requirements]

**Requirements:**
- Stage [specific files]
- Use [commit message format]
- Follow [branch naming convention]
- Handle [merge conflicts if any]

**Files Involved:**
- [Files to commit]
- [Branches involved]

**Success Criteria:**
- Changes are committed with proper message
- Commit follows project conventions
- No sensitive data included
- Git history is clean

**Constraints:**
- Follow commit message format
- Don't commit unrelated changes
- Resolve conflicts appropriately
- Don't force push without confirmation

**Priority:** [High/Medium/Low]
```

## Template Selection Guide

| Task Type | Template | Key Elements |
|-----------|---------|--------------|
| New feature | Code Development | Requirements, files, success criteria |
| Bug fix | Debugging | Context, symptoms, root cause analysis |
| Documentation | Documentation | Sections to update, accuracy, clarity |
| Performance issue | Performance | Profiling, bottlenecks, metrics |
| Security review | Security | Vulnerabilities, compliance, best practices |
| Testing | Testing | Scenarios, coverage, edge cases |
| Git operations | Git/Repository | Files, format, conventions |

## Command Quality Patterns

### ✅ Effective Command Patterns

**Be Specific:**
- ✅ "Fix the pagination bug in app/services/state.py where slice calculation uses post-increment"
- ❌ "Fix the task browser"

**Provide Context:**
- ✅ "Context: The bug occurs when all Redis keys arrive in a single SCAN batch, causing empty task lists"
- ❌ "Context: It's broken"

**Include Constraints:**
- ✅ "Constraints: Don't change the Redis connection logic, maintain existing error handling"
- ❌ "Constraints: Make it work"

**Define Success:**
- ✅ "Success Criteria: Pagination works for all batch sizes, no performance regression"
- ❌ "Success Criteria: It should be better"

**Mention Priority:**
- ✅ "Priority: High - blocking UI functionality"
- ❌ (no priority mentioned)

### ❌ Anti-Patterns to Avoid

**Vague Commands:**
- ❌ "fix the code"
- ❌ "update docs"
- ❌ "make it faster"

**Missing Context:**
- ❌ "The function is broken"
- ❌ "Add tests"
- ❌ "Optimize this"

**Over-Constrained:**
- ❌ "Use exactly this implementation: [paste 50 lines]"
- ❌ "Follow this exact step-by-step process"

**Undefined Success:**
- ❌ "improve the code"
- ❌ "make it better"
- ❌ "optimize it"

**Ambiguous Priority:**
- ❌ (no priority for urgent blocking issue)
- ❌ "Priority: urgent" (without context)

## Coordinator Mode vs Direct Commands

### When to Use Coordinator Mode

```
Please act as a coordinator to break down this complex task and delegate to appropriate specialists:

[Complex task description]

I need you to:
1. Analyze the task and identify specialist domains
2. Delegate to appropriate subagents
3. Synthesize their results
4. Provide a final recommendation

This task requires coordination between [different domains/specialists].
```

**Use coordinator mode when:**
- Task involves multiple technical domains
- You need explicit control over specialist selection
- Task is ambiguous and needs analysis first
- You want to monitor each step
- Task requires cross-domain synthesis

### When to Use Direct Commands

**Use direct commands when:**
- Task is clear and well-defined
- Task falls within one domain
- You want autonomous completion
- Task is straightforward
- You don't need to monitor intermediate steps

## Example: Command Evolution

### ❌ Poor Command
```
"Fix the task browser"
```

**Problems:**
- No context about what's broken
- No file locations
- No success criteria
- No constraints
- Vague scope

### ✅ Improved Command
```
Please fix the task browser pagination issue where task lists appear empty when all keys arrive in a single Redis SCAN batch.

**Context:**
The Redis pagination bug in app/services/state.py uses post-increment total instead of pre-increment for slice calculation, causing end-total==0 when all keys arrive in one batch.

**Requirements:**
- Fix the slice calculation in get_all_tasks method
- Track prev_total before incrementing
- Add logging for debugging
- Test with single-batch and multi-batch scenarios

**Files Involved:**
- app/services/state.py (lines 100-115)

**Success Criteria:**
- Pagination works correctly for all batch sizes
- Task lists display properly
- No performance regression

**Priority:** High
```

**Benefits:**
- Clear problem description
- Specific file location
- Implementation guidance
- Testable success criteria
- Appropriate urgency

## Template Customization

When adapting these templates for your project:

1. **Add project-specific sections** (e.g., "Deployment Requirements", "Compliance Requirements")
2. **Include project-specific constraints** (e.g., "Must pass CI pipeline", "Follow ADR process")
3. **Customize success criteria** for your quality standards
4. **Add project-specific file locations** (e.g., "src/api/", "infra/")
5. **Include project-specific priority levels** (e.g., "P0 - Critical", "P1 - High")
6. **Add project-specific approval requirements** (e.g., "Requires security review")

## Related Documentation

- `patterns/coordinator-optimization-patterns.md` — Coordinator behavioral patterns
- `patterns/coordinator-quick-reference.md` — Quick reference for coordinator behavior
- `templates/coordinator-template.md` — Coordinator agent template
