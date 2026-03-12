# TODO

Issues ordered by number, descending — highest (most recent) first.

---

## 7. New skill: `pickup` — smart delivery loop entry point

### Problem

The delivery loop (`explore-issue` → `plan` → `implement`) is well-defined but has no smart entry point. Today, "work on issue #N" always routes to `explore-issue`, which always runs the full exploration and design flow — even for simple tooling tasks where the problem, solution, and AC are already fully defined. There's also no skill that marks an issue as in-progress when work starts.

### What `pickup` does

Given a trigger like "let's work on issue #N", "pick up issue #N", or "start #N":

1. **Fetch the issue** from GitHub (or ask for manual input if unavailable — graceful degradation).
2. **Mark it in progress** — add an "in progress" label or move it in GitHub Projects.
3. **Check existing session artifacts** — look for `sessions/NNN-issue-title/context.md` and `plan.md`.
4. **Assess state and complexity**, then propose the next step:
   - `context.md` + `plan.md` exist → "Looks like we've already explored and planned this. Ready to implement?" → route to `implement`
   - `context.md` exists, no `plan.md` → "Exploration done, no plan yet. Ready to plan?" → route to `plan`
   - Nothing exists, issue is a `task` type with well-defined AC → "This looks straightforward — I can go straight to a plan, or explore first if you'd like." → user chooses
   - Nothing exists, issue is a user story or complex → "Let's explore this first." → route to `explore-issue`
5. **Wait for user confirmation** before routing — never route autonomously.

### Boundary changes

- `explore-issue` loses the "work on NNN" / "let's start NNN" triggers — those move to `pickup`. `explore-issue` is invoked by `pickup` or directly by the user when they want to explore.
- `pickup` owns the delivery loop entry point. `explore-issue`, `plan`, `implement` remain focused on their phases.

### Key design constraints

- Complexity assessment is a **suggestion, not a decision** — always confirm with the user before routing.
- Graceful degradation: if GitHub is unavailable, ask for manual input (same pattern as `explore-issue`).
- If session artifacts exist, summarise their state before suggesting the next step — same resume pattern as `explore-issue` Step 2.
- The "mark in progress" step should not block if the GitHub API call fails — note it and continue.

### Relation to existing TODOs

- Partially addresses **#3** (no skill owns the outer delivery loop) — not sprint planning, but the per-issue entry point now has an owner.
- Connects to **#1** (`/ship`) — `pickup` is the open of the issue lifecycle; `/ship` is the close.

---

## 6. Audit and fix remaining hard stops across skills

Skills should adapt and continue when inputs are missing or external operations fail — not halt and tell the user to fix their setup first. The following hard stops were identified and need graceful fallbacks:

1. **`implement` Step 1** — explicit stop when `plan.md` is missing. Ask the user to paste a plan, describe what to implement, or offer to invoke `plan` inline.

2. **`review` Step 1** — no fallback if `gh issue view` fails. Add the same manual-input fallback as `explore-issue`: accept issue title/description pasted directly, continue normally.

3. **`setup-project` Step 5** — blocks on Forge install confirmation. Make it non-blocking — Forge is only needed when running skills, not during repo scaffolding. Log the requirement and continue.

4. **`setup-project` Step 8** — blocks on GitHub API success for milestone/project board. If the API call fails, offer a manual path: "Create it at github.com/... and paste the URL, or skip and add it later."

5. **`setup-project` Step 9** — blocks on git push confirmation before handing off to `define-goals`. The handoff doesn't require the remote to be live — hand off immediately and let the push happen in parallel.

6. **`setup-project` Step 3** — waits for user to confirm `mkdir` succeeded. Auto-verify with a check instead; surface specific errors if creation fails.

7. **`write-adr` Step 2** — `next-number.sh` unresolvable if base directory is missing from context. Fall back to globbing `docs/ADRs/` directly to determine the next ADR number.

8. **`implement` Step 1 (ambiguity resolution)** — stalls when `context.md` is absent and plan ambiguities exist. Surface the ambiguity to the user directly rather than waiting silently.

---

## 5. Remove `[~]` in-progress marker from `implement`

**File:** `skills/implement/SKILL.md` — Step 2

The skill marks each task as `[~]` (in-progress) before working on it, then `[x]` when done. The three-state system (`[ ]` / `[~]` / `[x]`) adds write operations on every task start without reliable value — if a session is interrupted mid-task, the code is in a partial state regardless and Claude needs to re-examine the codebase to understand what was actually done.

**Proposed fix:** drop `[~]` entirely. Two states only: `[ ]` and `[x]`. On resume, Claude reads `plan.md` and scans the codebase against remaining tasks to find the next one. More reliable than a potentially stale marker.

---

## 4. Remove `validate.sh` from `implement` — replace with inline instructions

**File:** `skills/implement/SKILL.md` — Step 2, item 5 / `skills/implement/scripts/validate.sh`

`validate.sh` is a shell script that detects npm scripts in `package.json` and runs lint + typecheck + test. It should be removed for three reasons:

1. **Hardcodes `npm run`** — breaks for projects using `bun`, `pnpm`, or `yarn`. Package manager is known from `TECH.md`.
2. **Bundled file fragility** — resolved via plugin base directory path, same issue previously fixed in `explore-issue` and `write-adr`.
3. **Unnecessary abstraction** — Claude can do this check inline without a wrapper script.

**Proposed fix:** drop the script. Replace Step 2 item 5 with inline instructions: read `TECH.md` for the package manager, then run lint → typecheck → test using whatever's configured. Skip scripts that don't exist in `package.json`.

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

## 1. Lifecycle gap: `review` ends before the lifecycle closes

**File:** `skills/review/SKILL.md` — Step 4

When no blocking issues are found, the skill says "Ready to merge." and stops. There is no step for closing the issue, updating milestone progress, or checking whether a goal is now achieved.

**Trunk-based development context:** no branches or PRs. Work lands directly on main. So "merge" is implicit — the closing sequence is: close the GitHub issue, check milestone progress, check if any GOALS.md goal is now done.

**Two exit paths from `review`:**
1. No blockers → issue is done → needs a closing sequence
2. Blockers found → new tasks created → back into `plan` or `implement`

Closing only happens on exit path 1. It requires judgment — is this goal actually done? does this issue complete the milestone? — so it's not purely mechanical.

**Proposed direction:** a dedicated `/ship` skill (not `/close-issue`) invoked explicitly on exit path 1. It owns the full wiring:
- Close the GitHub issue
- Check milestone: if all issues done, close it
- Check GOALS.md: if a goal is now achieved, mark it done
- Invoke `commit` for any artifact updates

`review` on exit path 1 ends with: "No blockers. Run `/ship` to close the issue and update progress."

**What not to do:** don't add closing steps inside `review` — review has two exits and closing logic would only apply to one of them. A separate skill keeps the boundary clean.
