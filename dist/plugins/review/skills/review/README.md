# review

Reviews implementation before merge. Gathers issue context and design intent, delegates to a fresh-context code-reviewer agent, then drives fixes inline or escalates to `plan`.

## When to use

Say "review", "review the implementation", "let's review", "ready for review", or "before I merge".

## What it checks

- All acceptance criteria met
- Implementation matches agreed design intent
- Tests meaningful and passing (including a11y where applicable)
- Code clean and following project conventions
- Commits focused and correctly typed

## Minor vs significant

- **Minor issues** — fixed inline, validated, committed
- **Significant issues** — written to `sessions/NNN-issue-title/review.md`, escalated to `plan`
