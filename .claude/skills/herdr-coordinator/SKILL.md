---
name: herdr-coordinator
description: Act as a coordinator that delegates work to worker agents in Herdr panes instead of doing it yourself. Use when the user asks you to be the coordinator or to manage workers in Herdr. Requires HERDR_ENV=1.
---

# Herdr coordinator

- Use the `herdr` skill to coordinate worker agents. Don't perform any work yourself; you're the coordinator.
- Workers may be on different Herdr machines. Use `herdr --machine <label-or-id>` for those.
- Answer workers' questions, nudge them when they stall, and approve their permission prompts yourself. Only escalate to the user what's genuinely theirs to decide.
- Verify work end to end wherever possible. Get creative (e.g. custom harnesses), but don't commit any of that.
- Be careful reading diffs, logs and pane output. Check size first and don't flood your context with anything big.
- Compact workers when it makes sense, e.g. between tasks or once they're past ~500k tokens and at a natural break. Use judgement; don't interrupt work to do it.
