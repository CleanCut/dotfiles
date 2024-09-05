# Get our global profile stuff that we share with bash
source ~/.profile

# History File Settings
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# Add words that you never want to try to correct to this variable
CORRECT_IGNORE=""

# Initialize the ZSH Command Completion System
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '~/.zshrc'
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
autoload -Uz compinit
compinit
# Make it so that the mt function (defined in .profile) autocompletes arguments as files
compdef _files mt

# Enable Git Command Completion (do AFTER the ZSH Command Completion)
fpath=(~/.zsh $fpath)

# Enable Git Prompt Substitution
source ~/.gitcompletion/git-prompt.sh

# Shell Prompt Explanation
# ========================
#
# User (in red for root, green for other users) + "@"
# %(!.%F{red}%n%f.%F{green}%n%f)@
#
# Hostname (blue for workstations, purple for servers)
# `echo ${HOSTCOLOR}`%m%f
#
# Git repository and working status, if applicable, in yellow.
# %F{yellow}$(__git_ps1 " `git rev-parse --show-toplevel 2> /dev/null | xargs basename`->%s")%f
#
# If the shell was launched from Vim, display "VIM" in red.
# %F{red}$(vim_badge)%f
#
# Current working directory, no parent directories, use ~ for home.
# %1~
#
# If last command failed, print exit code in red
# %(?..%F{red}%?%f\n)
#
# If normal user, then green "$".  If priveleged user, then red "#".
# %(!.%F{red}#%f.%F{green}$%f)

# REMOVED -- USEFUL FOR EXAMPLE OF CUSTOM STUFF:
# Name of the flow project the current working directory is under
# %F{red}$(export CWD=$(pwd) ; if [[ $CWD == $HOME/sm/[a-z]* ]] ; then echo " $(IFS=/ read -r X Y <<< ${CWD:$(expr ${#HOME} + 4)} ; echo $X)" ; fi)

HOSTCOLOR='%F{magenta}'
for host in ${BLUEHOSTS}; do
    if [ $(hostname -s) = ${host} ]; then
        HOSTCOLOR='%F{blue}'
    fi
done
PS1='%(!.%F{red}%n@%f.%F{green}%n@%f)`echo ${HOSTCOLOR}`%m%f%F{red}$(export CWD=$(pwd) ; if [[ $CWD == $HOME/a2z/[a-z]* ]] ; then echo " $(IFS=/ read -r X Y <<< ${CWD:$(expr ${#HOME} + 5)} ; echo $X)" ; fi)%F{yellow}$(__git_ps1 " `git rev-parse --show-toplevel 2> /dev/null | xargs basename 2>/dev/null`->%s")%f%F{red}$(vim_badge)%f %1~ %(?..(%F{red}%?%f%) )%(!.%F{red}#%f.%F{green}$%f) '
PSZ='%1~ %(?..(%F{red}%?%f%) )%(!.%F{red}#%f.%F{green}$%f) '
PSDEMO='%1~ %(?..(%F{red}%?%f%) )%F{green}$%f '

# Key Bindings
# ============

# Use Emacs key shortcuts (instead of switching them to Vim-style since EDITOR
# is set to vim)
bindkey -e

# This binds the escape sequence that VS Code sends for forward delete to the correct behaviour, instead of interpreting the key as `~`
# See https://github.com/microsoft/vscode/issues/96741#issuecomment-623149392
bindkey "\e[3~" delete-char

# Changing Directories
# ====================

# Don't cycle through possible matches when pressing TAB repeatedly.
unsetopt auto_menu

# If the command is the name of a directory, change to that directory
setopt autocd

# Always push the last directory onto the stack (as if we did pushd)
setopt autopushd

# Completion
# ==========

# Expansion and Globbing
# ======================

# If a pattern for filename generation has no matches, leave it unchanged (like
# bash does)
unsetopt nomatch

# If numeric filenames are matched by a filename generation pattern, sort the
# filenames numerically rather than lexcographically.
setopt numeric_glob_sort

# Using the =~ operator will use Perl-Compatible Regular Expressions from the
# PCRE library instead of the regexp syntax provided by the system libraries.
setopt rematch_pcre

# History
# =======

# Save each command's beginning timestamp and duration to the history file in
# the format: ":beginning time:elapsed seconds;command"
setopt extended_history

# When a history expansion is entered, perform the expansion and reload the
# line into the editing buffer.
setopt hist_verify

# Enables "extended_history" and "inc_append_history" and causes shells to load
# each other's history after every command.
# setopt share_history

# Don't store commands in the history list if the first character on the line
# is a space, or when one of the expanded aliases contains a space.  Note that
# it will stay in internal (not stored on disk) history until the next command
# is entered.
setopt hist_ignore_space

# Input/Output
# ============

# Expand aliases
setopt aliases

# Use the Dvorak keyboard as a basis for examining spelling mistakes.
setopt dvorak

# Print the exit value of programs with non-zero exit status
# setopt print_exit_value

# Do not query the user before executing "rm *" or "rm path/*"
setopt rm_star_silent

# Job Control
# ===========

# List jobs in the long format by default
setopt long_list_jobs

# Report background job status immediately, rather than waiting until just
# before the next prompt.
# setopt notify

# Prompting
# =========

# Treat "%" specially in prompt sequences (to specify special values)
setopt prompt_percent

# Perform parameter expansion, command substitution and arithmetic expansion
# REQUIRED for the Git Prompt substitution stuff to work!
setopt prompt_subst

# Remove any right prompt from display when accepting a command line.
# setopt transient_rprompt

# ZSH-specific aliases
alias history="history 1"

# For "cheating" when livecoding a presentation
_cheat_completion() {
    local completions
    pushd ~/cheat >/dev/null
    completions="$(ls $1* 2>/dev/null)"
    popd >/dev/null
    reply=( "${(ps:\n:)completions}" )
}

function cheat() {
    if [ -f ~/cheat/$1 ] ; then
        cat ~/cheat/$1 | pbcopy
        echo "📋 Copied to clipboard! ($1)"
    else
        echo "😭 No cheat found for $1"
    fi
}

compctl -K _cheat_completion cheat
