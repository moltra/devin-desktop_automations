#!/bin/bash
# Install agent templates to local Devin configuration

set -e

DEVIN_CONFIG="$HOME/.config/devin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "Installing Devin agent templates..."
echo "Repository directory: $REPO_DIR"
echo "Target directory: $DEVIN_CONFIG"

# Create directories if they don't exist
mkdir -p "$DEVIN_CONFIG/agents"
mkdir -p "$DEVIN_CONFIG/skills"

# Copy agent templates
echo "Copying agent templates..."
cp -r "$REPO_DIR/templates/"* "$DEVIN_CONFIG/agents/"

# Copy skills (from .agents/skills/ following .agents standard)
echo "Copying skills..."
cp -r "$REPO_DIR/.agents/skills/"* "$DEVIN_CONFIG/skills/"

# Also copy legacy skills from skills/ directory if it exists
if [ -d "$REPO_DIR/skills" ]; then
    echo "Copying legacy skills..."
    cp -r "$REPO_DIR/skills/"* "$DEVIN_CONFIG/skills/"
fi

# Make scripts executable
echo "Making scripts executable..."
chmod +x "$REPO_DIR/scripts/"*.sh

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "1. Customize agents in $DEVIN_CONFIG/agents/ for your project"
echo "2. See CUSTOMIZATION.md for detailed guidance"
echo "3. Restart Devin to load the new configurations"
echo ""
echo "Your customized agents will remain in $DEVIN_CONFIG/agents/"
echo "and will not be affected by updates to this repository."
