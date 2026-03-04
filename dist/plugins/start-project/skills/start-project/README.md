# start-project

Bootstraps a new project repo from zero: GitHub repo, directory structure, workflow skills, CI baseline, and product scoping handoff.

## When to use

Say "start project", "bootstrap a new project", or "set up [project name]". Always the first skill invoked for a new project.

## What it does

1. Gathers project context from `PLAN.md` or asks you to supply it
2. Creates the GitHub repo
3. Scaffolds directory structure (`docs/`, `.github/`, `.claude/skills/`, `sessions/`)
4. Writes `README.md` as a product brief
5. Pulls Forge skills into the project
6. Writes `CLAUDE.md`
7. Scaffolds CI baseline (lint + test + build on every PR)
8. Creates the MVP milestone
9. Makes the initial bootstrap commit
10. Hands off to `define-goals`

## Handoff

After the bootstrap commit and push confirmation, runs `define-goals` to establish the product's initial scope.
