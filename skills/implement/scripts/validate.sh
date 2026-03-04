#!/usr/bin/env bash
# Runs lint + test + typecheck for the current project.
# Detects project type from package.json scripts and runs what exists.
# Exit code 0 = all checks passed. Non-zero = at least one check failed.

set -euo pipefail

PASS=0
FAIL=0

run_if_exists() {
  local label="$1"
  local script="$2"

  if node -e "const p = require('./package.json'); process.exit(p.scripts?.['$script'] ? 0 : 1)" 2>/dev/null; then
    echo "▶ $label"
    if npm run "$script" --silent; then
      echo "✅ $label passed"
      PASS=$((PASS + 1))
    else
      echo "❌ $label failed"
      FAIL=$((FAIL + 1))
    fi
  fi
}

if [ ! -f package.json ]; then
  echo "No package.json found — skipping npm validations"
  exit 0
fi

run_if_exists "lint" "lint"
run_if_exists "typecheck" "typecheck"
run_if_exists "type-check" "type-check"
run_if_exists "test" "test"

echo ""
echo "Results: $PASS passed, $FAIL failed"

[ "$FAIL" -eq 0 ]
