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

1. On every machine, check for uncommitted changes and distance from `origin/main`, and summarise for the user.
2. Commit only changes that belong on every machine. Ask about anything machine-specific (paths, hostnames, secrets, local tool setup).
3. Commit one logical change per commit on the machine that has it (stage hunks with `yadm apply --cached <patch>`), then `pull --rebase` and push. Go one machine at a time. Stop and ask on conflicts.
4. Pull on the other machines.
5. On randerson.dev, `git -C ~/.dotfiles checkout main` first (the submodule is often on a detached HEAD), then commit the submodule bump in the DDG yadm repo and push it. A file newly added to the shared repo also needs a symlink in `~` pointing into `~/.dotfiles`, like the existing ones.
6. Confirm all three machines are on the same commit.
