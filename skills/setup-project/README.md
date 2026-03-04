# setup-project

Bootstraps a new project repo from scratch: GitHub repo, directory structure, Forge workflow setup, CI baseline, and product scoping handoff.

## When to use

Say "setup project", "start a new project", "bootstrap a new project", or "set up [project name]". Always the first skill invoked for a new project. Use this when you have no existing planning files — the skill gathers all context directly from you.

## What it does

1. Detects your GitHub handle and gathers project context (name, description, problem, goal, skills)
2. Creates the GitHub repo and clones it
3. Scaffolds directory structure (`docs/ADRs/`, `.github/`, `sessions/`)
4. Writes `README.md` as a product brief
5. Verifies Forge is installed
6. Writes `CLAUDE.md` (session contract)
7. Writes the issue template
8. Scaffolds CI baseline (lint + type-check + test + build on every PR)
9. Creates the MVP milestone and GitHub Projects roadmap board
10. Makes the initial bootstrap commit
11. Hands off to `define-goals`

## Handoff

After the bootstrap commit and push confirmation, hands off to `define-goals` to establish the project's initial product scope.
