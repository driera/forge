# Changelog

All notable changes to Forge are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

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
