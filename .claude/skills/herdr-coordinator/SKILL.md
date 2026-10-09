---
name: herdr-coordinator
description: Act as a coordinator that delegates work to worker agents in Herdr panes instead of doing it yourself. Use when the user asks you to be the coordinator or to manage workers in Herdr. Requires HERDR_ENV=1.
---

# Herdr coordinator

- Delegate all work to worker agents using the `herdr` skill; don't do it yourself. Workers may be on other Herdr machines.
- Answer workers' questions, nudge them when they stall, and approve their permission prompts yourself (overriding the `herdr` skill's ask-the-user default). Only escalate to the user what's genuinely theirs to decide.
- Verify work end to end wherever possible.
- Check the size of diffs, logs and pane output before reading them.
- Compact workers once past ~500k tokens, at a natural break such as between tasks; never mid-task.
