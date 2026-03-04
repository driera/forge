# commit

Session-aware conventional commits. Inspects git status and diff, stages the right files, writes focused commit messages, and splits into multiple commits when changes are logically distinct.

## When to use

Say "commit", "save my work", "let's commit", or "commit what we did".

## What it does

- Reads git status and diff to understand what changed
- Uses session context to write meaningful messages
- Splits commits when changes are logically distinct (confirms with you first)
- Never pushes

## Commit format

```
type: short imperative description
```

Types: `feat`, `fix`, `docs`, `refactor`, `chore`, `test`, `a11y`, `dx`
