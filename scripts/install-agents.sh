#!/bin/bash
# Install or update Devin agent templates and skills to the local Devin configuration.
#
# Usage: bash scripts/install-agents.sh
#
# The script detects the Devin configuration directory based on the operating system:
#   - Linux/macOS: ~/.config/devin
#   - Windows (Git Bash/MSYS/Cygwin): $HOME/AppData/Roaming/devin
#
# Override the target directory by setting the DEVIN_CONFIG environment variable.

set -euo pipefail

shopt -s nullglob

# Detect Devin configuration directory.
detect_devin_config() {
    if [ -n "${DEVIN_CONFIG:-}" ]; then
        printf '%s' "$DEVIN_CONFIG"
        return
    fi

    local os
    os=$(uname -s)

    case "$os" in
        MINGW*|MSYS*|CYGWIN*|Windows_NT)
            # Git Bash, MSYS2, or Cygwin on Windows. Devin Desktop stores config
            # in %APPDATA%\devin (AppData/Roaming/devin).
            if [ -d "$HOME/AppData/Roaming" ]; then
                printf '%s/AppData/Roaming/devin' "$HOME"
            else
                printf '%s/.config/devin' "$HOME"
            fi
            ;;
        *)
            printf '%s/.config/devin' "$HOME"
            ;;
    esac
}

DEVIN_CONFIG=$(detect_devin_config)
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_DIR=$(dirname "$SCRIPT_DIR")

BACKUP_DIR="$DEVIN_CONFIG/backup-$(date +%Y%m%d-%H%M%S)"
AGENTS_DIR="$DEVIN_CONFIG/agents"
SKILLS_DIR="$DEVIN_CONFIG/skills"

printf 'Installing Devin agents and skills...\n'
printf 'Repository: %s\n' "$REPO_DIR"
printf 'Target:     %s\n' "$DEVIN_CONFIG"

mkdir -p "$AGENTS_DIR" "$SKILLS_DIR"
mkdir -p "$BACKUP_DIR"

# Backup the entire agents and skills directories if they already contain data.
if [ -d "$AGENTS_DIR" ] && [ "$(ls -A "$AGENTS_DIR" 2>/dev/null)" ]; then
    cp -r "$AGENTS_DIR" "$BACKUP_DIR/"
fi
if [ -d "$SKILLS_DIR" ] && [ "$(ls -A "$SKILLS_DIR" 2>/dev/null)" ]; then
    cp -r "$SKILLS_DIR" "$BACKUP_DIR/"
fi

printf '\nInstalling/updating agents...\n'
for template in "$REPO_DIR/templates/"*.md; do
    [ -f "$template" ] || continue

    name=$(basename "$template" .md | sed 's/-template$//')
    target_dir="$AGENTS_DIR/$name"
    target_file="$target_dir/AGENT.md"

    if [ -f "$target_file" ]; then
        printf '  Updating agent: %s\n' "$name"
    else
        printf '  Installing agent: %s\n' "$name"
    fi

    mkdir -p "$target_dir"
    cp "$template" "$target_file"
done

printf '\nInstalling/updating skills...\n'
install_skills_from() {
    local source_dir="$1"
    if [ ! -d "$source_dir" ]; then
        return
    fi

    for skill_dir in "$source_dir"/*/; do
        [ -d "$skill_dir" ] || continue

        local name
        name=$(basename "$skill_dir")
        local target_dir="$SKILLS_DIR/$name"

        if [ -d "$target_dir" ]; then
            printf '  Updating skill: %s\n' "$name"
            rm -rf "$target_dir"
        else
            printf '  Installing skill: %s\n' "$name"
        fi

        cp -r "$skill_dir" "$target_dir"
    done
}

install_skills_from "$REPO_DIR/.agents/skills"
install_skills_from "$REPO_DIR/.devin/skills"

printf '\nInstallation complete.\n'
printf 'Backup: %s\n' "$BACKUP_DIR"
printf '\nNext steps:\n'
printf '1. Review backed-up files if you had customizations.\n'
printf '2. Restart Devin to load the updated configurations.\n'
