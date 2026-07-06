#Requires -Version 5.1
<#
.SYNOPSIS
    Install or update Devin agent templates and skills to the local Devin configuration.

.DESCRIPTION
    Detects the Devin configuration directory on Windows (%APPDATA%\devin), then
    installs agent templates as named AGENT.md profiles and copies skills from both
    .agents/skills and .devin/skills. Existing files are backed up before overwriting.

.PARAMETER DevinConfig
    Override the target Devin configuration directory.

.EXAMPLE
    .\scripts\install-agents.ps1

.EXAMPLE
    .\scripts\install-agents.ps1 -DevinConfig "C:\Users\Me\AppData\Roaming\devin"
#>
[CmdletBinding()]
param(
    [string]$DevinConfig = ""
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $PSCommandPath
$repoDir = Split-Path -Parent $scriptDir

if ($DevinConfig) {
    $devinConfig = $DevinConfig
} else {
    $devinConfig = Join-Path $env:APPDATA "devin"
}

$backupDir = Join-Path $devinConfig ("backup-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
$agentsDir = Join-Path $devinConfig "agents"
$skillsDir = Join-Path $devinConfig "skills"

Write-Host "Installing Devin agents and skills..."
Write-Host "Repository: $repoDir"
Write-Host "Target:     $devinConfig"

New-Item -ItemType Directory -Force -Path $agentsDir | Out-Null
New-Item -ItemType Directory -Force -Path $skillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

# Backup existing agents and skills if they contain data.
if (Test-Path $agentsDir) {
    $children = Get-ChildItem -Path $agentsDir -Force
    if ($children) {
        Copy-Item -Path $agentsDir -Destination $backupDir -Recurse -Force
    }
}
if (Test-Path $skillsDir) {
    $children = Get-ChildItem -Path $skillsDir -Force
    if ($children) {
        Copy-Item -Path $skillsDir -Destination $backupDir -Recurse -Force
    }
}

Write-Host "`nInstalling/updating agents..."
$templates = Get-ChildItem -Path (Join-Path $repoDir "templates") -Filter "*.md"
foreach ($template in $templates) {
    $name = $template.BaseName -replace '-template$', ''
    $targetDir = Join-Path $agentsDir $name
    $targetFile = Join-Path $targetDir "AGENT.md"

    if (Test-Path $targetFile) {
        Write-Host "  Updating agent: $name"
    } else {
        Write-Host "  Installing agent: $name"
    }

    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Copy-Item -Path $template.FullName -Destination $targetFile -Force
}

Write-Host "`nInstalling/updating skills..."
function Install-SkillsFrom {
    param([string]$SourceDir)

    if (-not (Test-Path $SourceDir)) {
        return
    }

    $skillDirs = Get-ChildItem -Path $SourceDir -Directory
    foreach ($skillDir in $skillDirs) {
        $name = $skillDir.Name
        $targetDir = Join-Path $skillsDir $name

        if (Test-Path $targetDir) {
            Write-Host "  Updating skill: $name"
        } else {
            Write-Host "  Installing skill: $name"
        }

        Copy-Item -Path $skillDir.FullName -Destination $targetDir -Recurse -Force
    }
}

Install-SkillsFrom -SourceDir (Join-Path (Join-Path $repoDir ".agents") "skills")
Install-SkillsFrom -SourceDir (Join-Path (Join-Path $repoDir ".devin") "skills")

Write-Host "`nInstallation complete."
Write-Host "Backup: $backupDir"
Write-Host "`nNext steps:"
Write-Host "1. Review backed-up files if you had customizations."
Write-Host "2. Restart Devin to load the updated configurations."
