# Coordinator Workflow Patterns

This document describes common coordinator delegation patterns for multi-agent workflows.

## Standard Development Workflow

```
coordinator → domain-specialist → python-reviewer → testing-guardian → security-auditor → coordinator
```

**Use when:** Implementing new features, bug fixes, or code changes

**Steps:**
1. Coordinator analyzes task and identifies domain
2. Delegate to appropriate specialist (python-developer, api-specialist, etc.)
3. Python-reviewer validates code quality
4. Testing-guardian ensures test coverage
5. Security-auditor checks for vulnerabilities
6. Coordinator synthesizes results and provides final verdict

## API Development Workflow

```
coordinator → api-specialist → python-reviewer → testing-guardian → security-auditor → git-workflow
```

**Use when:** Creating or modifying API endpoints

**Steps:**
1. Coordinator identifies API work needed
2. API-specialist designs and implements endpoints
3. Python-reviewer validates code quality and patterns
4. Testing-guardian ensures API tests are comprehensive
5. Security-auditor checks for API security issues
6. Git-workflow handles commit and merge process

## Streamlit Application Workflow

```
coordinator → streamlit-expert → python-reviewer → testing-guardian → security-auditor → coordinator
```

**Use when:** Working on Streamlit UI components

**Steps:**
1. Coordinator identifies UI work needed
2. Streamlit-expert implements UI components with performance optimization
3. Python-reviewer validates code quality
4. Testing-guardian ensures UI tests are comprehensive
5. Security-auditor checks for XSS and input validation
6. Coordinator synthesizes results

## Infrastructure Setup Workflow

```
coordinator → devops-docker → security-auditor → coordinator
```

**Use when:** Setting up or modifying infrastructure

**Steps:**
1. Coordinator identifies infrastructure work needed
2. Devops-docker specialist implements infrastructure changes
3. Security-auditor validates security of infrastructure
4. Coordinator provides final recommendations

## Performance Investigation Workflow

```
coordinator → subagent_explore → domain-specialist → python-reviewer → coordinator
```

**Use when:** Investigating performance issues

**Steps:**
1. Coordinator identifies performance investigation needed
2. Subagent_explore investigates codebase to identify bottlenecks
3. Domain-specialist (redis/streamlit/etc.) optimizes specific areas
4. Python-reviewer validates optimization changes
5. Coordinator synthesizes findings and recommendations

## Security Review Workflow

```
coordinator → python-reviewer → security-auditor → coordinator
```

**Use when:** Conducting security reviews

**Steps:**
1. Coordinator identifies security review needed
2. Python-reviewer checks code quality and potential issues
3. Security-auditor conducts comprehensive security analysis
4. Coordinator synthesizes security findings and recommendations

## Git Workflow

```
coordinator → git-workflow → python-reviewer → security-auditor → git-workflow
```

**Use when:** Handling git operations (commits, merges, branches)

**Steps:**
1. Coordinator identifies git operation needed
2. Git-workflow specialist handles git operations
3. Python-reviewer validates code quality before commit
4. Security-auditor checks for security issues
5. Git-workflow completes the operation

## Parallel Delegation Pattern

```
coordinator → [specialist A, specialist B, specialist C] (parallel) → coordinator
```

**Use when:** Multiple independent subtasks can be executed simultaneously

**Example:**
```
coordinator → [python-reviewer, security-auditor, testing-guardian] (parallel) → coordinator
```

**Benefits:**
- Faster execution for independent tasks
- Better resource utilization
- Reduced overall completion time

## Sequential Delegation Pattern

```
coordinator → specialist A → specialist B → specialist C → coordinator
```

**Use when:** Subtasks depend on each other or must be executed in order

**Example:**
```
coordinator → python-developer → python-reviewer → testing-guardian → coordinator
```

**Benefits:**
- Ensures correct order of operations
- Allows each specialist to build on previous work
- Maintains dependencies between tasks

## Mixed Pattern

```
coordinator → [specialist A, specialist B] (parallel) → specialist C → coordinator
```

**Use when:** Some subtasks are independent, others depend on results

**Example:**
```
coordinator → [python-reviewer, security-auditor] (parallel) → git-workflow → coordinator
```

**Benefits:**
- Optimizes for both parallel and sequential dependencies
- Reduces overall completion time while maintaining correctness
- Flexible for complex workflows

## Error Handling in Workflows

### Specialist Failure Handling

If a specialist subagent fails:
1. Coordinator should log the failure
2. Attempt to understand the failure from available context
3. Either retry with different approach or escalate to user
4. Document the failure in final synthesis

### Conflicting Recommendations

When specialists provide conflicting recommendations:
1. Coordinator should identify the conflict
2. Analyze the reasoning behind each recommendation
3. Prioritize based on severity and impact
4. Document the conflict and resolution in final synthesis
5. Escalate to user if conflict cannot be resolved

## Customization Notes

When customizing these workflows for your project:

1. **Add project-specific workflows** for your common development patterns
2. **Include project-specific specialist combinations** for your tech stack
3. **Add project-specific error handling patterns** for your infrastructure
4. **Include project-specific validation steps** in workflows
5. **Add project-specific escalation procedures** for your team structure
