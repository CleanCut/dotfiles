# A login shell that is not interactive (`zsh -l -c`) reads no `.zshrc`, so it takes its PATH from
# `.path` here, after macOS's path_helper has run. An interactive shell gets it through `.profile`.
if [[ ! -o interactive ]]; then
    source ~/.path
    # Drop the entries `.path` repeats, keeping each where it first appears.
    typeset -U path
    path=($path)
fi
