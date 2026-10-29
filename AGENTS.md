# Dotfiles

Nathan's shell, git, editor, and terminal setup, in the **public** repo [CleanCut/dotfiles](https://github.com/CleanCut/dotfiles). Anything secret, credentialed, machine-specific, or about an employer's private systems goes in `~/.private` instead, which `~/.private/AGENTS.md` lays out. The test before adding a line here: would it be fine on GitHub for anyone to read?

## How it reaches `~`

`./install` links the repo into the home directory, so the files in `~` are this repo's files:

| In the repo | In `~` | How |
|---|---|---|
| `homefiles/.<name>` | `~/.<name>` | symlink, for every dotfile in `homefiles/` |
| `bin/`, `gitcompletion/`, `tmux/`, `vim/` | `~/.bin/`, `~/.gitcompletion/`, `~/.tmux/`, `~/.vim/` | directory symlink |
| `config/zed/` | `~/.config/zed/` | directory symlink |
| `font/*` | `~/Library/Fonts/*` | hard link |
| `copilot/agents/*` | `~/.copilot/agents/*` | symlink per agent |

Because these are symlinks, editing `~/.gitconfig` and editing `homefiles/.gitconfig` change the same file, and the change shows in this repo's `git status`. Prefer the repo path when editing, so the diff is obvious.

`install` also installs Rust if it is missing, `cargo install`s the Rust CLI tools, runs `brew bundle` on `Brewfile` (macOS), resets every vim plugin submodule (`git submodule deinit -f --all`, then `update --init`), and suggests `~/.private/install`. Rerunning it is safe but slow, so do not run it to apply a small change: make the one link or install by hand, or ask Nathan.

## Where a change goes

- **A shell alias, function, or environment variable:** `homefiles/.profile`. zsh loads it through `homefiles/.zshrc` (`source ~/.profile`), and bash reads it directly. Keep zsh-only setup (completion, prompt, key bindings) in `.zshrc`.
- **A secret or machine-specific variable:** `~/.private/homefiles/.profile-private.sh`, which the end of `.profile` sources when it exists. Never here.
- **`PATH`:** `homefiles/.path`, one `export PATH=...` line that `.profile` sources.
- **Git settings:** `homefiles/.gitconfig` (the pager is delta, configured under `[delta]`). Global ignores go in `homefiles/.gitignore-global`.
- **A script to run from anywhere:** `bin/`, on `PATH` as `~/.bin`. A script that carries anything private goes in `~/.private/sbin` (`~/.sbin`). `bin/oxen*` is gitignored, for local builds of the `oxen` binaries.
- **A CLI tool:** a Rust crate goes in `install`'s "Installing Rust cli tools" list as `cargo install -q <crate>`, and anything else in `Brewfile`. Prefer `cargo install` for a tool written in Rust.
- **A vim plugin:** a git submodule under `vim/bundle/`, added with `git submodule add`, so `.gitmodules` records it.
- **Zed:** `config/zed/settings.json` and `keymap.json`. VS Code's `vscode/settings.json` is a copy kept to share with people, not linked anywhere.
- **tmux:** `homefiles/.tmux.conf`, with more configs in `tmux/`.
- **iTerm2:** `iterm2/`, holding iTerm2's preferences plist. `install` only mentions it and links nothing.

## Checking a change

- Run `bash -n install` after editing `install`, and `shellcheck` (installed in `~/.local/bin`) on any shell file you change. `.profile` carries `shellcheck` directives, so keep it clean under it.
- After editing `.profile`, `.path`, or `.zshrc`, check it in a fresh shell (`zsh -lic 'echo ok'`) rather than sourcing it into one that is already set up.
- After editing `.gitconfig`, `git config --get <key>` confirms git reads the value, and `git config --get-regexp '^pager\.'` shows any per-command pager that would override `core.pager`.

## Committing

Nathan commits here himself unless he says to, and often has his own uncommitted edits (to `homefiles/.profile`, say), so commit only the paths you changed (`git commit -- <paths>`). His go-ahead to commit covers the push, as the global config describes.

## This file

`AGENTS.md` is the instruction file, with `.claude/CLAUDE.md -> ../AGENTS.md` for Claude Code. `.gitignore` ignores the rest of `.claude/`, which holds this machine's local Claude Code settings.
