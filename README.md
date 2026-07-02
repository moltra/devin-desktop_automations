# Devin Desktop Automations

A comprehensive multi-agent system configuration for Devin AI, featuring specialized sub-agents for various development domains.

## Overview

This repository contains the configuration and architecture for a Devin multi-agent system designed to automate and streamline development workflows. The system uses a hierarchical delegation pattern where a coordinator agent orchestrates specialized sub-agents for specific tasks.

## Architecture

The system consists of 11 specialized agents organized into functional groups:

### Coordinator
- **coordinator**: Main orchestrator using glm-5-2-high model for task delegation and synthesis

### Code & Development
- **python-reviewer**: Code quality and review specialist
- **api-specialist**: API design and implementation
- **testing-guardian**: Test quality and validation

### Infrastructure
- **streamlit-expert**: UI architecture and Streamlit applications
- **redis-engineer**: Caching strategies and Redis integration
- **ollama-specialist**: LLM integration and Ollama management
- **devops-docker**: Container orchestration and deployment

### Security & Quality
- **security-auditor**: Security scanning and vulnerability assessment
- **video-pipeline-reviewer**: Video processing pipeline optimization

### Git Operations
- **git-workflow**: Branch management and commit workflows

## Repository Structure

```
.
├── agents/                 # Agent configurations
│   ├── api-specialist/
│   ├── coordinator/
│   ├── devops-docker/
│   ├── git-workflow/
│   ├── ollama-specialist/
│   ├── python-reviewer/
│   ├── redis-engineer/
│   ├── security-auditor/
│   ├── streamlit-expert/
│   ├── testing-guardian/
│   └── video-pipeline-reviewer/
├── skills/                 # Reusable skill configurations
│   ├── ollama-testing/
│   ├── quick-review/
│   └── redis-resilience/
├── scripts/                # Utility scripts
│   ├── review_code.py
│   └── pre-commit-config.template.yaml
├── cli/                    # CLI tools (empty)
├── hooks/                  # Git hooks (empty)
├── config.json             # Main Devin configuration
├── agent-architecture.md   # Architecture documentation
├── CRITICAL_LESSONS.md     # Important lessons learned
└── DEVELOPMENT_GUIDE.md    # Development guidelines
```

## Configuration

The main configuration is in `config.json` and includes:

- **MCP Servers**: GitHub, Git, Filesystem, Memory, DeepWiki, Playwright, Redis
- **Permissions**: Fine-grained access control for different tools and paths
- **Agent Profiles**: Model assignments and tool permissions for each agent

## Workflow Patterns

### API Development
```
coordinator → api-specialist → python-reviewer → testing-guardian → security-auditor → coordinator
```

### Streamlit App Development
```
coordinator → streamlit-expert → python-reviewer → testing-guardian → security-auditor → coordinator
```

### Infrastructure Setup
```
coordinator → devops-docker → security-auditor → coordinator
```

### Git Workflow
```
coordinator → git-workflow → python-reviewer → security-auditor → git-workflow → coordinator
```

## Model Selection

- **glm-5-2-high**: Used for complex tasks requiring high capability (coordinator, code review, security, video)
- **kimi-k2-7**: Used for focused, efficient task execution (infrastructure, testing, git)

## Key Design Principles

1. **Single Responsibility**: Each agent has a clear, focused domain
2. **Hierarchical Delegation**: Coordinator breaks down tasks, specialists execute
3. **Parallel Execution**: Independent subtasks run concurrently when possible
4. **Cross-Validation**: Code reviewed by multiple specialists
5. **Safe Operations**: Git and destructive operations have limited permissions

## Setup

1. Clone this repository
2. Copy agent configurations to your Devin config directory:
   ```bash
   cp -r agents/* ~/.config/devin/agents/
   cp -r skills/* ~/.config/devin/skills/
   cp config.json ~/.config/devin/
   ```
3. Adjust paths and permissions in `config.json` as needed
4. Restart Devin to load the new configurations

## Documentation

- `agent-architecture.md`: Detailed architecture diagram and workflow patterns
- `CRITICAL_LESSONS.md`: Important lessons and best practices
- `DEVELOPMENT_GUIDE.md`: Development guidelines and workflows

## Contributing

When adding new agents or skills:
1. Create the agent/skill directory following the existing structure
2. Add appropriate documentation in the `AGENT.md` or `SKILL.md` file
3. Update `agent-architecture.md` if the architecture changes
4. Update `config.json` with necessary permissions
5. Test the configuration before committing

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
