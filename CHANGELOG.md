# Changelog

All notable changes to Forge are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Added
- `write-opportunity`: new skill to register product opportunities — raw signals, pain points, or intuitions worth exploring before any solution is committed. Creates a GitHub issue with the `opportunity` label; only populates fields that emerge from conversation.
- `setup-project`: creates `.github/ISSUE_TEMPLATE/opportunity.md` during project bootstrap

---

## [1.9.0] — 2026-04-04

### Changed
- `explore-issue`: full design presented in one message instead of section-by-section; single feedback round before writing context.md
- `explore-issue`: offers to chain to `plan` after context.md is saved — one "ok" is enough
- `plan`: offers to chain to `implement` after plan is confirmed
- `implement`: runs an entire commit group autonomously; pauses once at the commit boundary for feedback before committing
- `implement`: offers to chain to `review` after the last commit
- `review`: offers to chain to `ship` when no blocking issues are found

---

## [1.8.2] — 2026-04-04

### Changed
- `explore-issue`: removed artifact commit at the end — context.md is saved but not committed
- `plan`: removed artifact commit after confirmation — plan.md is saved but not committed
- `implement`: first commit group now stages uncommitted session artifacts (context.md, plan.md) alongside implementation files

---

## [1.8.1] — 2026-04-04

### Changed
- `write-issue`: issue body templates extracted to `templates/user-story.md` and `templates/task.md`. Skill now loads from `.github/ISSUE_TEMPLATE/` when present, falling back to bundled templates.

---

## [1.8.0] — 2026-03-16

### Added
- `ship`: new skill that closes the issue lifecycle after a clean review — closes the GitHub issue, checks milestone progress, and marks GOALS.md goals as achieved (with confirmation).

### Changed
- `review`: Step 4 no-blockers path now hands off to `/ship` instead of stopping at "Ready to merge."

---

## [1.7.0] — 2026-03-16

### Changed
- `explore-issue`: added "Dependencies" as Phase 2 design section 3 (between Components and Data Flow) — captures new packages with rationale during design.
- `explore-issue/templates/context.md`: added `### Dependencies` + `{DEPENDENCIES}` placeholder.
- `plan`: if `context.md` lists new packages under `### Dependencies`, opens the plan with a dedicated install task (own commit group, no types/test cases). If no `context.md`, asks about packages as part of manual intake.

---

## [1.6.1] — 2026-03-16

### Changed
- `implement`: removed `[~]` in-progress task marker — tasks are now either `[ ]` or `[x]`, no intermediate state.
- `implement`: replaced `validate.sh` script with inline validation instructions — reads `TECH.md` for the package manager, then runs lint → typecheck → test using whatever scripts are configured. Deleted `scripts/validate.sh`.

---

## [1.6.0] — 2026-03-16

### Changed
- `plan`: replaced "one commit per task" with explicit commit groups — `Commit:` markers in the plan define boundaries; `implement` commits when it hits one. Merged `Bite-size tasks` + `Feature-complete tasks` into a single `Task scope` principle. Fixed `What to implement` guidance to describe observable outcomes, not function names. Added `TECH.md` as an optional input.
- `implement`: commits at group boundaries defined in the plan, not after every task.

---

## [1.5.0] — 2026-03-16

### Changed
- `implement`: replaced hard stop for missing `plan.md` with an offer — user can paste a plan, point to a file, invoke `plan`, or describe what to implement.
- `review`: added manual-input fallback if `gh issue view` fails — user can paste the issue title and description directly.
- `write-adr`: Step 2 now falls back to globbing `docs/ADRs/*.md` if the script can't run. If `docs/ADRs/` doesn't exist, asks the user to confirm creation or provide an alternate destination.
- `setup-project`: removed four hard stops — Step 3 auto-verifies directory creation; Step 5 (Forge install) no longer blocks; Step 8 (GitHub API) offers a manual path on failure; Step 9 hands off to `define-goals` immediately without waiting for push confirmation.

---

## [1.4.0] — 2026-03-12

### Changed
- `explore-issue`: merged `exploration.md` + `design.md` into a single `context.md` (Problem → Solution structure). Removed `exploration.md` as a deliverable — problem context now lives in the top half of `context.md`. Added fallback for non-GitHub users: if `gh` fails or no issue is found, skill asks for a manual description and continues normally.
- `plan`: reads `context.md` instead of two separate files. Falls back to asking the user if no session file exists — works with JIRA, Notion, or any non-Forge input.
- `review`: reads `context.md` instead of `design.md`.
- `commit`: updated session artifact list to reflect `context.md`.
- `define-tech`: removed claim of generating a CI workflow file. CI is always a backlog task — toolchain scripts must exist before CI can be wired up.
- `write-issue`: short descriptive titles for user stories (story sentence moves to `## Goal` in body). Removed "PR linked and merged" from DoD. `Proposed Solution` is now optional for tasks — only for complex cases. Label guidance added: suggests based on context, always confirms. AC quality guidance per type: user-observable outcomes for stories, technical verifiable states for tasks. Links to referenced files encouraged.
- `setup-project`: issue templates updated to match — `feature` / `tooling` default labels, `## Goal` for user stories, `Proposed Solution` optional for tasks, "PR linked and merged" removed from DoD.

---

## [1.3.0] — 2026-03-10

### Added
- `define-tech`: new skill that leads a tech stack and toolchain conversation, writes `TECH.md`, and seeds `BACKLOG.md` with first engineering task issues (CI last, depends on all other toolchain tasks).

### Changed
- `define-goals`: inception mode now proposes first product issues and writes them to `BACKLOG.md`, then hands off to `define-tech` instead of ending with no guidance.
- `setup-project`: removed hardcoded Node.js + npm CI workflow (Step 8). CI is now generated by `define-tech` based on confirmed stack. README Status section includes `[Tech →](TECH.md)` placeholder. Handoff chain updated to reflect `define-goals → define-tech`.

---

## [1.2.1] — 2026-03-10

### Fixed
- `explore-issue`: Step 4 now includes explicit dispatch instructions for the `codebase-explorer` agent — what to populate `{ISSUE_SUMMARY}` and `{SEARCH_TARGETS}` with, and how to use the output in subsequent steps.

---

## [1.2.0] — 2026-03-07

### Added
- `setup-project`: scaffolds two issue templates — `user-story.md` and `task.md`.
  `task.md` covers engineering work (toolchain, refactors, infrastructure) with a
  Problem / Context / Proposed Solution structure.
- `write-issue`: supports two issue types. Infers type from context (user-story vs task)
  and drafts using the appropriate template. Task titles use short imperative format
  instead of user-story format.

---

## [1.1.2] — 2026-03-07

### Fixed
- `explore-issue`, `write-adr`, `implement`: replaced hardcoded `.claude/skills/...` paths
  with base-directory-relative references. Skills now resolve templates and scripts from
  `Base directory for this skill` provided in the system context, compatible with the plugin model.

---

## [1.1.1] — 2026-03-07

### Fixed
- `write-issue`: resolved hardcoded `driera` GitHub handle. Owner and repo are now
  parsed from `git remote get-url origin`, with fallback to `gh auth status`. Works
  for any GitHub account or organisation.

---

## [1.1.0] — 2026-03-05

### Added
- `setup-project`: self-contained bootstrap skill. Gathers all project context directly
  from the user (GitHub handle, project name, description, problem, v1 goal, skills showcased)
  with no dependency on external planning files. Works for any Forge adopter.

### Removed
- `start-project`: portfolio-specific bootstrap that read `context.md` and `PLAN.md` and
  hardcoded `driera/` as the GitHub handle. Not suitable for a public skill library.

---

## [1.0.1] — 2026-03-05

### Changed
- `start-project`: skills are now installed via `/plugin marketplace add driera/forge`
  instead of being copied per-project. Added `WORKFLOW_VERSION` to the CLAUDE.md template.

---

## [1.0.0] — 2026-03-04

### Added
- Initial skill set: `commit`, `define-goals`, `explore-issue`, `implement`, `plan`,
  `review`, `skill-creator`, `start-project`, `write-adr`, `write-issue`
- Marketplace manifest at `.claude-plugin/marketplace.json`
- CI validation for skill structure and dist/ sync
