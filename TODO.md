# TODO

Issues ordered by number, descending — highest (most recent) first.

---

## 3. Gap: no skill owns the outer delivery loop

After bootstrap and the initial backlog are created, the workflow relies entirely on the user to manage the backlog, pick the next issue, and decide when to reprioritize or evolve goals. No skill covers:

- Sprint planning or issue prioritization
- Deciding what to work on next from GitHub Projects
- Knowing when to run `/define-goals` again to evolve product scope

The delivery loop (`explore-issue` → `plan` → `implement` → `review`) is well defined per issue, but the outer loop — across issues and sprints — has no owner. This may warrant a new skill (`plan-sprint`?) or a convention documented in CLAUDE.md templates.

---

## 2. Design vision gap: advisory tone is absent across all skills

Skills currently execute — they don't propose. No skill opens with a suggestion and asks for validation before acting. The intended experience is:

> "As I know how to help you, here's what I'd suggest for this step: [proposal]. Does this match where you want to go? Any changes before I proceed?"

This consultative moment is missing everywhere. `setup-project` creates things without proposing the structure. `define-goals` interviews without framing what a healthy outcome looks like. `explore-issue` is the closest — it proposes approaches and asks section by section — but even it doesn't open with an upfront orientation.

This is not a single-skill fix. It is a tone and interaction design principle that needs to be applied across the whole skill set, starting with `setup-project` and `define-goals` where first impressions are formed.

---

## Done

### ✅ 1. Lifecycle gap: `review` ends before the lifecycle closes

Added `/ship` skill — closes the GitHub issue, checks milestone progress, marks GOALS.md goals as achieved. `review` Step 4 now hands off to `/ship` on the no-blockers path. Released in v1.8.0.

### ✅ 9. Improve plan and implement skill quality

Replaced per-task commits with explicit commit groups (plan defines `Commit:` boundaries; implement commits when it hits one). Merged `Bite-size tasks` + `Feature-complete tasks` into a single `Task scope` principle. Fixed `What to implement` to describe observable outcomes, not function names. Added `TECH.md` as optional input. Released in v1.6.0.

### ~~7. New skill: `pickup`~~ — won't do

Claude Code handles session resume naturally. The only value was marking issues in-progress, which isn't worth a dedicated skill.

### ✅ 8. Track dependencies during exploration, install in plan

Added "Dependencies" as design section 3 in `explore-issue` Phase 2. Added `### Dependencies` + `{DEPENDENCIES}` to `context.md` template. `plan` now opens with a dedicated install task when packages are listed, and asks about packages during manual intake. Released in v1.7.0.

### ✅ 5. Remove `[~]` in-progress marker from `implement`

Dropped the three-state system — tasks are now `[ ]` or `[x]` only. Released in v1.6.1.

### ✅ 4. Remove `validate.sh` from `implement` — replace with inline instructions

Deleted `scripts/validate.sh`. Step 2 now reads `TECH.md` for the package manager and runs lint → typecheck → test inline. Released in v1.6.1.

### ✅ 6. Audit and fix remaining hard stops across skills

Replaced hard stops in `implement`, `review`, `setup-project`, and `write-adr` with graceful fallbacks — skills now ask, adapt, or continue rather than halting. Released in v1.5.0.
