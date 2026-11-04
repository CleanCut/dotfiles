# A login shell that is not interactive (`zsh -l -c`) reads no `.zshrc`, so it takes its PATH from
# `.path` here, after macOS's path_helper has run. An interactive shell gets it through `.profile`.
if [[ ! -o interactive ]]; then
    source ~/.path
    # Put Homebrew and then mise's shims ahead of macOS's own tools, the order an interactive shell
    # has, so `python3` is a current one (or the one a repo's `.tool-versions` pins) rather than
    # /usr/bin's 3.9, which coord runs found first.
    for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [[ -x $brew ]]; then
            eval "$($brew shellenv zsh)"
            break
        fi
    done
    if command -v mise >/dev/null; then
        eval "$(mise activate zsh --shims)"
    fi
    # Drop the entries repeated above, keeping each where it first appears.
    typeset -U path
    path=($path)
fi
