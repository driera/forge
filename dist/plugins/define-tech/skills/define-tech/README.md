# define-tech

Defines the tech stack and toolchain for a new project. Leads a conversation about language, framework, package manager, and tooling, then produces `TECH.md`, a tailored CI workflow, and first engineering task issues.

## When to use

Say "define tech", "set up the toolchain", or "what stack should we use". Also triggered automatically at the end of `define-goals` during project inception.

## What it covers

- Language, runtime, and framework
- Package manager (npm / pnpm / yarn / bun)
- Linter, formatter, type checker, test runner, build tool
- Deploy target

## Output

- `TECH.md` — technical source of truth, linked from README
- `BACKLOG.md` — first engineering task issues appended (including CI as the last task), ready for `/write-issue`
