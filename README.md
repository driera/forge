# Forge

> A versioned collection of Claude skills for structured agentic software development.

## What it is

Forge is a set of Claude Code skills that define a complete, opinionated delivery workflow — from bootstrapping a new project to exploring issues, planning, implementing, and reviewing. Skills are individually installable as Claude plugins.

The workflow follows two loops:

**Inception** — run once at project start, repeatable for product evolution:
```
setup-project → define-goals → define-tech → write-issue
```

**Delivery** — repeating per increment:
```
explore-issue → plan → implement → review
```

`write-adr` floats across both — triggered when a significant architectural decision is made.

## Skills

| Skill | Purpose |
|---|---|
| [`setup-project`](skills/setup-project/) | Bootstrap a new project repo |
| [`define-goals`](skills/define-goals/) | Create or evolve GOALS.md — the product source of truth |
| [`define-tech`](skills/define-tech/) | Define tech stack, toolchain, and seed engineering backlog |
| [`write-issue`](skills/write-issue/) | Create GitHub issues in user-story or task format |
| [`explore-issue`](skills/explore-issue/) | Explore an issue's problem space and drive design |
| [`plan`](skills/plan/) | Break approved design into ordered, testable tasks |
| [`implement`](skills/implement/) | Execute the plan task by task following TDD |
| [`review`](skills/review/) | Review implementation before merge |
| [`write-adr`](skills/write-adr/) | Document architectural decisions |
| [`commit`](skills/commit/) | Create focused, conventional commits |
| [`skill-creator`](skills/skill-creator/) | Create, improve, or review skills |

## Installation

Add the Forge marketplace to Claude Code:

```
/plugin marketplace add driera/forge
```

Then install individual skills:

```
/plugin install commit@forge
/plugin install explore-issue@forge
```

Or install all skills at once:

```
/plugin install *@forge
```

## Philosophy

Forge is opinionated. These decisions shape every skill:

**Test-driven and intentional.** Tests written before or alongside code. Small, focused commits. No shortcuts for speed.

**Trunk-based development.** No branches, no pull requests. Work lands directly on main in small, intentional commits. The delivery loop is the quality gate — explore, plan, implement, review — not Git ceremony.

**Outcome-driven goals.** Product goals describe what becomes true for users, never solutions or features. "Artists can share their work with a global audience" is a goal. "Build an upload form" is not. Goals drive issues; issues drive the loop.

**Deliberate before fast.** Every issue goes through exploration and design before a line of code is written. The loop exists to surface problems early — not to slow things down, but to avoid building the wrong thing.

**GitHub as the source of truth for delivery.** Issues track work, milestones track progress, GitHub Projects tracks the roadmap. Every piece of work has a GitHub issue behind it — nothing gets built off the side of a conversation.

**Graceful degradation over hard stops.** Skills adapt when inputs are missing or the expected workflow wasn't followed. If a GitHub issue isn't available, ask for a description. If a session file is missing, ask for context. Sense what's needed and continue — never halt and tell the user to fix their setup first.

**JS/TS first.** Toolchain defaults — linter, formatter, type checker, test runner, build — are designed for JavaScript and TypeScript projects. Other stacks are supported through conversation but not scaffolded by default.

---

## Version

See [CHANGELOG.md](CHANGELOG.md) for release history.
