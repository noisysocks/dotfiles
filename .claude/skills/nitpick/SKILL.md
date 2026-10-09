---
name: nitpick
description: Review the current branch's changes for over-engineering, unnecessary comments, test quality and consistency with the codebase, and report findings. Use when the user asks to nitpick a diff or review it for tidiness.
context: fork
agent: general-purpose
---

# Nitpick

Review the branch diff against its base for:

- Over-engineering.
- Unnecessary comments.
- Tests: too many, too few, or testing implementation instead of behaviour.
- Inconsistency with the codebase's style.

Don't make changes. Reply with a list of findings, each with file, line and suggested fix.
