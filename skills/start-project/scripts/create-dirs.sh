#!/usr/bin/env bash
# Creates the standard directory structure for a new project.
# Run from within the project root.

set -euo pipefail

mkdir -p docs/ADRs
mkdir -p .github/ISSUE_TEMPLATE
mkdir -p .github/workflows
mkdir -p .claude/skills
mkdir -p sessions

echo "✅ Created: docs/ADRs/"
echo "✅ Created: .github/ISSUE_TEMPLATE/"
echo "✅ Created: .github/workflows/"
echo "✅ Created: .claude/skills/"
echo "✅ Created: sessions/"
