# Devin Desktop Automations - Agent Templates

A comprehensive collection of **generic agent templates and patterns** for Devin AI multi-agent systems. These templates provide a foundation for building specialized sub-agents while keeping project-specific knowledge private.

## Overview

This repository contains **generic agent templates, patterns, and documentation** that can be customized for any project. The templates are designed to be copied to your local Devin configuration and then adapted to your specific needs.

## Architecture

The system uses a hierarchical delegation pattern where a coordinator agent orchestrates specialized sub-agents for specific tasks.

### Available Templates

#### Coordinator
- **coordinator-template**: Main orchestrator for task delegation and synthesis

#### Code & Development
- **python-reviewer-template**: Code quality and review specialist
- **api-specialist-template**: API design and implementation
- **testing-guardian-template**: Test quality and validation

#### Infrastructure
- **streamlit-expert-template**: UI architecture and Streamlit applications
- **redis-engineer-template**: Caching strategies and Redis integration
- **ollama-specialist-template**: LLM integration and Ollama management
- **devops-docker-template**: Container orchestration and deployment

#### Security & Quality
- **security-auditor-template**: Security scanning and vulnerability assessment
- **video-pipeline-reviewer-template**: Video processing pipeline optimization

#### Git Operations
- **git-workflow-template**: Branch management and commit workflows

## Repository Structure

```
.
├── templates/                 # Generic agent templates
│   ├── coordinator-template.md
│   ├── python-reviewer-template.md
│   ├── streamlit-expert-template.md
│   ├── redis-engineer-template.md
│   ├── ollama-specialist-template.md
│   ├── security-auditor-template.md
│   ├── git-workflow-template.md
│   └── etc.
├── patterns/                  # Generic patterns and workflows
│   ├── coordinator-optimization-patterns.md
│   ├── coordinator-quick-reference.md
│   ├── task-template-patterns.md
│   ├── task-templates-quick-reference.md
│   ├── skills-integration-patterns.md
│   ├── skills-quick-reference.md
│   ├── delegation-patterns.md
│   ├── streamlit-performance.md
│   └── redis-patterns.md
├── .agents/                   # Devin skills (tool-agnostic standard)
│   └── skills/
│       ├── coordinator/
│       ├── python-reviewer/
│       ├── security-auditor/
│       ├── redis-engineer/
│       ├── testing-guardian/
│       ├── streamlit-expert/
│       ├── git-workflow/
│       ├── ollama-testing/
│       ├── quick-review/
│       └── redis-resilience/
├── .devin/                    # Devin-native skills
│   └── skills/
│       ├── coordinator/
│       ├── git-workflow/
│       ├── python-reviewer/
│       ├── redis-engineer/
│       ├── security-auditor/
│       ├── streamlit-expert/
│       └── testing-guardian/
├── documentation/             # Documentation
│   ├── agent-architecture.md
│   ├── CRITICAL_LESSONS.md
│   ├── DEVELOPMENT_GUIDE.md
│   └── CREATING_AGENTS.md
├── patterns/                  # Reusable patterns
│   ├── agent-telemetry.json   # Telemetry JSON schema
│   ├── agent-telemetry.md   # Telemetry agent instructions
│   └── ...
├── scripts/                   # Utility scripts
│   ├── install-agents.sh     # Unix / Git Bash installer
│   ├── install-agents.ps1    # Windows PowerShell installer
│   └── validate-agent.sh
├── CUSTOMIZATION.md           # How to customize templates
└── README.md                 # This file
```

## Installation

### Quick Start

#### Option A: Run the installer without cloning (standalone)

The installer can download the repository automatically if it is not already present.

**Linux / macOS / Git Bash on Windows:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/moltra/devin-desktop_automations/master/scripts/install-agents.sh)
```

**Windows PowerShell:**
```powershell
irm https://raw.githubusercontent.com/moltra/devin-desktop_automations/master/scripts/install-agents.ps1 | iex
```

#### Option B: Clone first, then install

1. **Clone this repository:**
   ```bash
   git clone https://github.com/moltra/devin-desktop_automations.git
   cd devin-desktop_automations
   ```

2. **Install or update templates and skills:**

   **Linux / macOS / Git Bash on Windows:**
   ```bash
   bash scripts/install-agents.sh
   ```

   **Windows PowerShell:**
   ```powershell
   .\scripts\install-agents.ps1
   ```

The installer asks whether to install **locally** (current project: `./.devin`) or
**globally** (user Devin config: `~/.config/devin/` or `%APPDATA%\devin\`). On
non-interactive terminals it defaults to global.

Skip the prompt by passing the scope explicitly:

**Linux / macOS / Git Bash:**
```bash
bash scripts/install-agents.sh          # prompts for local/global
INSTALL_MODE=local bash scripts/install-agents.sh
INSTALL_MODE=global bash scripts/install-agents.sh
```

**Windows PowerShell:**
```powershell
.\scripts\install-agents.ps1            # prompts for local/global
.\scripts\install-agents.ps1 -Local
.\scripts\install-agents.ps1 -Global
```

3. **Customize for your project:**
   - For **global** installs, edit agent configurations in `~/.config/devin/agents/` (Linux/macOS) or `%APPDATA%\devin\agents\` (Windows)
   - For **local** installs, edit agent configurations in `./.devin/agents/`
   - Add project-specific patterns and knowledge
   - Adjust permissions and tool access
   - Update model assignments if needed

4. **Restart Devin** to load the new configurations

### Manual Installation

If you prefer manual installation, place each agent template in its own directory
with the file named `AGENT.md`, and copy each skill directory into the skills folder:

```bash
# Linux / macOS example
mkdir -p ~/.config/devin/agents/coordinator
mkdir -p ~/.config/devin/agents/python-reviewer
# ... one directory per agent

cp templates/coordinator-template.md ~/.config/devin/agents/coordinator/AGENT.md
cp templates/python-reviewer-template.md ~/.config/devin/agents/python-reviewer/AGENT.md

# Copy skills from both .agents and .devin standards
cp -r .agents/skills/* ~/.config/devin/skills/
cp -r .devin/skills/* ~/.config/devin/skills/

# Make scripts executable
chmod +x scripts/*.sh
```

**Note:** Agents are installed as `AGENT.md` files inside named directories (e.g.,
`agents/coordinator/AGENT.md`). Skills are stored in `.agents/skills/` and
`.devin/skills/` following the `.agents` and `.devin` skills standards for broad
compatibility with third-party tools.

## Customization

### Project-Specific Customization

After installing the templates, you should customize them for your project:

1. **Add Project Knowledge:**
   - Add project-specific file paths
   - Include business logic patterns
   - Document internal architecture
   - Add configuration details

2. **Adjust Permissions:**
   - Add project-specific tool permissions
   - Configure file access patterns
   - Set up Docker/container permissions
   - Configure API access

3. **Update Models:**
   - Choose appropriate models for your use case
   - Adjust model parameters
   - Configure model-specific behaviors

See [CUSTOMIZATION.md](CUSTOMIZATION.md) for detailed customization guidelines.

## Workflow Patterns

### Standard Development Workflow
```
coordinator → domain-specialist → python-reviewer → testing-guardian → security-auditor → coordinator
```

### API Development
```
coordinator → api-specialist → python-reviewer → testing-guardian → security-auditor → git-workflow
```

### Infrastructure Setup
```
coordinator → devops-docker → security-auditor → coordinator
```

### Performance Investigation
```
coordinator → subagent_explore → domain-specialist → python-reviewer → coordinator
```

## Key Design Principles

1. **Single Responsibility**: Each agent has a clear, focused domain
2. **Hierarchical Delegation**: Coordinator breaks down tasks, specialists execute
3. **Parallel Execution**: Independent subtasks run concurrently when possible
4. **Cross-Validation**: Code reviewed by multiple specialists
5. **Safe Operations**: Git and destructive operations have limited permissions
6. **Privacy First**: Project-specific knowledge stays in your local configuration

## Documentation

- [CUSTOMIZATION.md](CUSTOMIZATION.md): How to customize templates for your project
- [patterns/coordinator-optimization-patterns.md](patterns/coordinator-optimization-patterns.md): Coordinator behavioral patterns for efficiency
- [patterns/coordinator-quick-reference.md](patterns/coordinator-quick-reference.md): Quick reference for coordinator behavior
- [patterns/task-template-patterns.md](patterns/task-template-patterns.md): Task construction templates
- [patterns/task-templates-quick-reference.md](patterns/task-templates-quick-reference.md): Quick reference for task templates
- [patterns/skills-integration-patterns.md](patterns/skills-integration-patterns.md): Skills integration guide
- [patterns/skills-quick-reference.md](patterns/skills-quick-reference.md): Quick reference for available skills
- [patterns/delegation-patterns.md](patterns/delegation-patterns.md): Structural delegation patterns
- [patterns/streamlit-performance.md](patterns/streamlit-performance.md): Streamlit optimization patterns
- [patterns/redis-patterns.md](patterns/redis-patterns.md): Redis integration patterns
- [documentation/agent-architecture.md](documentation/agent-architecture.md): Detailed architecture documentation
- [documentation/CRITICAL_LESSONS.md](documentation/CRITICAL_LESSONS.md): Important lessons learned
- [documentation/DEVELOPMENT_GUIDE.md](documentation/DEVELOPMENT_GUIDE.md): Development guidelines

## Contributing

When contributing new templates or patterns:

1. Keep them **generic and reusable** across projects
2. Remove any **project-specific information** (paths, configs, business logic)
3. Add **clear documentation** for customization
4. Update relevant documentation files
5. Test the template before submitting

## Privacy & Security

This repository contains **only generic templates and patterns**.

**What IS shared:**
- Generic agent configurations
- Reusable patterns and workflows
- Best practices and guidelines
- Documentation and examples

**What is NOT shared:**
- Project-specific file paths
- Business logic details
- Proprietary algorithms
- Internal architecture diagrams
- Configuration values (API keys, secrets)
- Custom agent implementations

Keep your project-specific customizations in your local `~/.config/devin/agents/` directory - these should never be committed to this repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For issues or questions:
1. Check the documentation in the `documentation/` directory
2. Review [CUSTOMIZATION.md](CUSTOMIZATION.md) for guidance
3. Open an issue on GitHub for template-specific problems
