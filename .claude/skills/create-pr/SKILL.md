---
name: create-pr
description: Open a pull request for the current work with a title and description matching the user's previous PRs and the repo's template. Use when the user asks to create, open or raise a PR.
---

# Create PR

1. If you're on the default branch, create a branch. Commit any uncommitted changes.
2. Read the repo's PR template and the user's last few PRs in this repo (`gh pr list --author @me --state all -L 5 --json title,body`).
3. Write a title and description that follow the template and match those PRs in style, structure and length. Fill in links (e.g. the Asana task) if you know them; otherwise leave the placeholder.
4. Push the branch and run `gh pr create --draft`. Only leave out `--draft` if the user said to publish. If a PR already exists for the branch, update its title and body instead.
