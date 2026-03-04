# implement

Executes the implementation plan from `plan.md` task by task, following TDD, with a report-and-feedback cycle before each commit.

## When to use

Say "implement", "start implementing", or "let's code". Also triggered automatically at the end of `plan`.

## What it does

- Reviews the plan critically before touching code
- Per task: TDD cycle → validate → report → commit → next task
- Detects minor deviations (notes and continues) vs significant ones (stops and proposes a fix)
- Summarises all changes at the end

## Resume

Detects completed tasks in `plan.md` and summarises state before continuing.
