# Changelog

All notable changes to Forge are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

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
