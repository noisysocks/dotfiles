---
name: autopilot
description: Complete a task end to end without check-ins: implement, verify, nitpick, code review, then open a draft PR. Use when the user says autopilot or asks to take a task all the way to a PR.
---

# Autopilot

1. Do the work, delegating independent parts to subagents.
2. Verify with tests, lint, type checks, and end to end where possible.
3. Run the `nitpick` skill, then the `code-review` skill at medium effort. Fix valid findings and verify again.
4. Open a PR with the `create-pr` skill.
5. Report anything left unverified or unresolved.
