---
name: sync-dotfiles
description: Sync dotfiles (Claude Code config, zshrc, gitconfig, nvim, tmux, herdr) between this Mac, WSL and randerson.dev using yadm. Use when the user asks to sync dotfiles or config, or to push/pull yadm changes.
---

# Sync dotfiles

The shared repo is `git@github.com:noisysocks/dotfiles.git` (`main`). It's checked out differently on each machine:

| Machine | How to reach | Layout |
|---|---|---|
| Mac | local | `yadm` repo over `~` |
| WSL | `ssh wsl` | `yadm` repo over `~`; the binary is `/home/linuxbrew/.linuxbrew/bin/yadm` (not on the non-interactive PATH) |
| randerson.dev | `ssh randerson.dev` | `yadm` tracks a separate DDG repo (`dub.duckduckgo.com:randerson/yadm`, `master`). The shared repo is a git submodule at `~/.dotfiles`, and files in `~` are symlinks into it. Use plain `git -C ~/.dotfiles` for shared changes. |

## Steps

1. On every machine, check for uncommitted changes and how far it is from `origin/main` (`yadm status -sb`, `yadm fetch`; on randerson.dev, `git -C ~/.dotfiles status` and fetch). Show the user a short summary.
2. Look at each diff. Commit only changes that belong on every machine. If something looks machine-specific (paths, hostnames, secrets, local tool setup), ask the user instead of committing it.
3. Commit on the machine that has the change, one commit per logical change (when one file holds unrelated changes, stage just the relevant hunks by writing a patch and running `yadm apply --cached <patch>`), each with a short plain title and no prefix (e.g. `Add Ayu Mirage theme to herdr`), then `pull --rebase` and push. If several machines have changes, do them one at a time so each rebases on the last. Stop and ask on conflicts.
4. Pull on the other machines (`yadm pull --rebase`). On randerson.dev, `git -C ~/.dotfiles checkout main && git -C ~/.dotfiles pull --rebase` (the submodule is often on a detached HEAD), then commit the submodule bump in the DDG yadm repo and push it. A file newly added to the shared repo also needs a symlink in `~` on randerson.dev pointing into `~/.dotfiles`, like the existing ones.
5. Report what was committed, where, and that all three are on the same commit.
