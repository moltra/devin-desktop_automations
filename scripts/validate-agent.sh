#!/bin/bash
# Validate agent configuration files

set -e

AGENT_DIR="${1:-$HOME/.config/devin/agents}"

echo "Validating agent configurations in: $AGENT_DIR"

# Check if directory exists
if [ ! -d "$AGENT_DIR" ]; then
    echo "Error: Directory $AGENT_DIR does not exist"
    exit 1
fi

# Check for required agent files
echo "Checking for required agent files..."

required_agents=(
    "coordinator"
    "python-reviewer"
    "git-workflow"
    "security-auditor"
)

for agent in "${required_agents[@]}"; do
    if [ ! -f "$AGENT_DIR/$agent/AGENT.md" ]; then
        echo "Warning: Missing agent configuration: $agent"
    else
        echo "✓ Found: $agent"
    fi
done

# Validate YAML frontmatter in agent files
echo ""
echo "Validating YAML frontmatter..."

find "$AGENT_DIR" -name "AGENT.md" -type f | while read -r file; do
    if ! head -20 "$file" | grep -q "^---"; then
        echo "Warning: Missing YAML frontmatter in: $file"
    else
        echo "✓ Valid frontmatter: $(basename $(dirname "$file"))"
    fi
done

# Check for common issues
echo ""
echo "Checking for common configuration issues..."

find "$AGENT_DIR" -name "AGENT.md" -type f | while read -r file; do
    # Check for required fields
    if ! grep -q "^name:" "$file"; then
        echo "Warning: Missing 'name' field in: $file"
    fi
    if ! grep -q "^description:" "$file"; then
        echo "Warning: Missing 'description' field in: $file"
    fi
    if ! grep -q "^model:" "$file"; then
        echo "Warning: Missing 'model' field in: $file"
    fi
done

echo ""
echo "Validation complete!"
echo ""
echo "Next steps:"
echo "1. Review any warnings above"
echo "2. Test agent functionality"
echo "3. Customize agents for your project if needed"
