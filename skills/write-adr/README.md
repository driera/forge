# write-adr

Creates an Architecture Decision Record (ADR) in `docs/ADRs/`. Works in two modes depending on whether the decision has already been made.

## When to use

Say "write an ADR", "document this decision", or "capture this". Also proactively suggested by Claude at specific workflow moments: end of `explore-issue` design phase, end of a prerequisite resolution, end of `review` if a significant approach change was required.

## Two modes

- **Closed decision** — decision already made. Claude confirms the decision and rationale, then writes the ADR.
- **Open decision** — not yet decided. Claude presents the problem space, proposes 2–3 options with tradeoffs, leads with a recommendation, reaches a decision with you, then documents it.

## Output

`docs/ADRs/NNN-kebab-title.md` — numbered sequentially, committed at the end of the skill.
