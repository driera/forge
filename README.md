# Forge

> A versioned collection of Claude skills for structured agentic software development.

## What it is

Forge is a set of Claude Code skills that define a complete, opinionated delivery workflow — from bootstrapping a new project to exploring issues, planning, implementing, and reviewing. Skills are individually installable as Claude plugins.

The workflow follows two loops:

**Inception** — run once at project start, repeatable for product evolution:
```
start-project → define-goals → write-issue
```

**Delivery** — repeating per increment:
```
explore-issue → plan → implement → review
```

`write-adr` floats across both — triggered when a significant architectural decision is made.

## Skills

| Skill | Purpose |
|---|---|
| [`start-project`](skills/start-project/) | Bootstrap a new project repo |
| [`define-goals`](skills/define-goals/) | Create or evolve GOALS.md — the product source of truth |
| [`write-issue`](skills/write-issue/) | Create GitHub issues in user-story format |
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

## Version

See [CHANGELOG.md](CHANGELOG.md) for release history.
