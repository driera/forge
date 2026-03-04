---
name: skill-creator
description: Create new skills, modify, improve, or review existing skills. Use when users want to create a skill from scratch, update or iterate on an existing skill, or review a skill for quality and alignment. Always invoke this skill when the user says "make a skill for X", "create a skill", "update the skill", "review the skill", or similar.
---

# Skill Creator

A skill for writing and iterating on skills.

Figure out where the user is when they invoke this skill and jump in at the right point:
- **New skill**: they have an idea, you need to draw out the intent and write it
- **Existing skill to improve or adapt**: they have feedback or a change to make — go straight to editing
- **Review**: they want a critique — read the skill, assess it, give structured feedback

The core loop: understand → draft → review with user → improve. Repeat until satisfied. If the user says "just vibe with me" or doesn't want a structured process, that's fine — be flexible.

---

## Communicating with the user

Pay attention to context cues for technical familiarity. Most users here are developers, but not always. When in doubt, briefly explain terms rather than assuming.

---

## Creating a skill

### Capture Intent

Start by understanding the user's intent. If the current conversation already contains a workflow the user wants to capture (e.g., "turn this into a skill"), extract answers from the conversation history first — the tools used, the sequence of steps, corrections the user made, input/output formats observed. Fill gaps with the user and confirm before writing.

Key questions to answer before drafting:
1. What should this skill enable Claude to do?
2. When should it trigger? (what user phrases or contexts)
3. What's the expected output?

### Interview and Research

Ask about edge cases, input/output formats, success criteria, and dependencies before writing. Come prepared — if there are similar skills or relevant docs to check, do it first to reduce the burden on the user.

### Write the SKILL.md

Fill in:

- **name**: Skill identifier
- **description**: When to trigger and what it does. This is the primary triggering mechanism — include both what the skill does AND the specific contexts for when to use it. Claude tends to undertrigger skills, so make descriptions a little pushy. Instead of *"How to build a dashboard"*, write *"How to build a dashboard. Use this whenever the user mentions dashboards, metrics, or wants to display data, even if they don't say 'dashboard'."*
- **the rest of the skill**

### Skill Writing Guide

#### Anatomy of a Skill

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description required)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/    - Executable code for deterministic/repetitive tasks
    ├── references/ - Docs loaded into context as needed
    └── assets/     - Files used in output (templates, icons, fonts)
```

#### Progressive Disclosure

Skills use a three-level loading system:
1. **Metadata** (name + description) — Always in context
2. **SKILL.md body** — In context whenever skill triggers (keep under 500 lines)
3. **Bundled resources** — Loaded as needed (unlimited)

**Key patterns:**
- Keep SKILL.md under 500 lines; if approaching the limit, add a layer of hierarchy with clear pointers to reference files
- Reference bundled files clearly from SKILL.md with guidance on when to read them
- For large reference files (>300 lines), include a table of contents

**Domain organization** — when a skill supports multiple variants, organize by variant:
```
cloud-deploy/
├── SKILL.md (workflow + selection)
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```
Claude reads only the relevant reference file.

#### Principle of Lack of Surprise

Skills must not contain malware, exploit code, or anything that could compromise system security. A skill's contents should not surprise the user given its description. Don't create misleading skills or skills designed for unauthorized access, data exfiltration, or other malicious uses.

#### Writing Patterns

Prefer imperative form in instructions.

**Defining output formats:**
```markdown
## Report structure
Use this exact template:
# [Title]
## Executive summary
## Key findings
## Recommendations
```

**Examples:**
```markdown
## Commit message format
**Example:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

### Writing Style

Explain the *why* behind instructions rather than issuing blunt commands. LLMs are smart — when they understand the reasoning, they can apply it to cases you didn't anticipate. If you find yourself writing ALWAYS or NEVER in all caps, or using rigid structures, that's a signal to step back and explain the reasoning instead. Write a draft, then read it with fresh eyes and improve it.

---

## Improving a skill

### How to think about improvements

Whether the feedback comes from the user directly or from reviewing the skill yourself, a few principles make rewrites better:

1. **Generalize from the feedback.** You're writing for a million future invocations, not just the example in front of you. Rather than adding narrow, case-specific rules, try to understand the underlying problem and address it at that level. Overly specific rules make skills brittle.

2. **Keep it lean.** Remove things that aren't pulling their weight. Shorter skills are easier to follow and leave more room for the model to apply judgment. If something can be removed without losing meaning, remove it.

3. **Explain the why.** If the model understands why something matters, it can apply that understanding to cases the skill didn't anticipate. Instructions that just say what to do, without the reasoning, break at the edges.

### The iteration loop

After improving the skill:

1. Apply your improvements to the skill
2. Show the user what changed and why
3. Ask for feedback
4. Repeat until the user is happy or there's nothing left to improve

Keep going until:
- The user says they're happy
- The feedback is all positive or empty
- You're not making meaningful progress

Once the user is satisfied, invoke the `commit` skill. Suggested message:
- New skill: `feat(skills): add <skill-name> skill`
- Updated skill: `fix(skills): update <skill-name> skill`
