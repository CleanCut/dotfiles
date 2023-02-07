#!/bin/bash
# shellcheck source=/dev/null disable=2034

# Set $OS to macos, debian, ubuntu, etc.
if [ "$(uname)" = "Darwin" ] ; then
    OS="macos"
else
    # shellcheck disable=SC1091
    . /etc/os-release
    OS="$ID"
fi

if [ "$OS" = "debian" ] ; then
    # Debian sources .profile by default in some part of the X login using /bin/sh,
    # but it doesn't need any of my bash/zsh stuff at that point (and the syntax
    # makes X crash)
    if [ "$BASH_VERSION" = "" ] ; then
        return
    fi
fi

# Colors
BLACK="\[\033[0;30m\]"
WHITE="\[\033[1;37m\]"
NO_COLOR="\[\033[0m\]"

BLUE="\[\033[0;34m\]"
CYAN="\[\033[0;36m\]"
GRAY="\[\033[1;30m\]"
GREEN="\[\033[0;32m\]"
PURPLE="\[\033[0;35m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"

LIGHT_BLUE="\[\033[1;34m\]"
LIGHT_CYAN="\[\033[1;36m\]"
LIGHT_GRAY="\[\033[0;37m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_YELLOW="\[\033[1;33m\]"

vim_badge() {
    if [ "$VIMRUNTIME" != "" ] ; then
        echo -n " VIM"
    else
        echo -n ""
    fi
}

# Make sure .ssh/config permissions are correct
[ -f ~/.ssh/config ] && chmod 644 ~/.ssh/config
# Make sure .ssh symlink permissions are correct on macos (linux symlinks don't have independent perms)
[ -d ~/.ssh ] && [ "$OS" = "macos" ] && chmod -h 700 ~/.ssh
# Make sure actual ssh dir and up through $HOME have perms that make ssh happy
[ -d ~/.private/ssh ] && chmod 700 ~/.private/ssh && chmod 700 ~/.private && chmod 700 ~/
# Create the sockets dir if it doesn't already exist
[ -d ~/.ssh ] && [ ! -d ~/.ssh/sockets ] && mkdir ~/.ssh/sockets


if [ "$OS" = "macos" ] ; then
    if ! cat /tmp/ssh_added 2> /dev/null > /dev/null ; then
        ssh-add ~/.ssh/id_rsa 2> /tmp/key-adding-result
        if [ "$(head -n 1 /tmp/key-adding-result)" = "No identity found in the keychain." ] ; then
            echo "Your ssh identity isn't in the keychain yet.  To add it, run: ssh-add -K ~/.ssh/id_rsa"
        else
            touch /tmp/ssh_added
        fi
    fi
fi

# Hostnames to color blue in the prompt
BLUEHOSTS=('fire' 'ice', 'boxy')
CLICOLOR=""
GOPATH="$HOME/.go"
INFOPATH=$INFOPATH:/opt/local/share/info
LESS="-RFX" # Pass thru colors, don't page less than one screen, don't clear the screen afterwards
LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.sh=01;32:*.csh=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:"
MANPATH=$MANPATH:/opt/local/share/man
source "$HOME/.path"
TMUX_SHELL=$(if which reattach-to-user-namespace &>/dev/null ; then echo "reattach-to-user-namespace -l $SHELL" ; else  echo "$SHELL -l" ; fi)
RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

export BLUEHOSTS CLICOLOR GOPATH INFOPATH LESS LS_COLORS MANPATH PATH TMUX_SHELL RIPGREP_CONFIG_PATH

# Depends on PATH being exported
EDITOR=$(which vim)
export EDITOR


# Bash-specific stuff, in case I decide to come back from ZSH...
if [[ -n "$BASH_VERSION" ]] ; then
    HOSTCOLOR=${PURPLE}
    for host in "${BLUEHOSTS[@]}" ; do
        if [[ "$(hostname -s)" == "${host}" ]] ; then
            HOSTCOLOR=${BLUE}
        fi
    done
    DOLLARCOLOR=${GREEN}
    if [[ "$(whoami)" == "root" ]] ; then
        DOLLARCOLOR=${RED}
    fi
    source ~/.gitcompletion/git-prompt.sh
    source ~/.gitcompletion/git-completion.bash
    # shellcheck disable=SC2089
    PS1="$DOLLARCOLOR\u@$NO_COLOR$HOSTCOLOR\h$YELLOW"'$(__git_ps1 " `git rev-parse --show-toplevel 2> /dev/null | xargs basename 2> /dev/null`->%s")'"$RED"'$(vim_badge)'"$NO_COLOR \W $DOLLARCOLOR\$$NO_COLOR "
    PSZ="$NO_COLOR\W $DOLLARCOLOR\$$NO_COLOR "

    # shellcheck disable=SC2090
    export PS1 PSZ
fi

# Show unstaged (*) and staged (+) changes.
GIT_PS1_SHOWDIRTYSTATE="1"
# Show if something is stashed ($)
GIT_PS1_SHOWSTASHSTATE="1"
# Show untracked files (%)
GIT_PS1_SHOWUNTRACKEDFILES="1"
# Show number of commits different from upstream (verbose), relative to the git upstream.
GIT_PS1_SHOWUPSTREAM="auto"
# On a detached head, show the number of commits of of the nearest NEWER branch or tag.
GIT_PS1_DESCRIBE_STYLE="branch"

export GIT_PS1_SHOWDIRTYSTATE GIT_PS1_SHOWSTASHSTATE GIT_PS1_SHOWUNTRACKEDFILES GIT_PS1_SHOWUPSTREAM GIT_PS1_DESCRIBE_STYLE

alias clean='clear && find . -name __pycache__ -exec rm -rf \{\} \;'
alias dc='docker-compose'
alias dcb='docker-compose build'
alias dcs='docker-compose stop'
alias dcu='docker-compose up'
alias ddk='docker rm $(docker ps -a -q)'
alias demo='export PS1=$PSDEMO'
alias doc='cargo doc --no-deps --open'
alias dstats='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}"'
alias f='find . -name '

# See .zshrc for how we enabled filename tab-completion for this function under zsh
function mt () {
    if [ "$OS" == "macos" ] ; then
        if [ "$(mvim --serverlist)" == "" ] ; then
            # MacVim is not open, just open with any arguments as files in tabs
            mvim -p "$@"
        else
            # MacVim is already open
            if [ "$1" == "" ] ; then
                # Not trying to open a file, so just focus MacVim
                open -a MacVim
            else
                # Open files in tabs
                mvim --remote-tab-silent "$@"
            fi
        fi
    else
        gvim --remote-tab "$@"
    fi
}
export mt

function sizeof () {
    IGNORE=""
    if [[ $2 != "" ]] ; then
        IGNORE="-I $2"
    fi
    du -k ${=IGNORE} $1 | tail -n 1 | cut -f 1 | awk '{s=$1*1024} END {printf "%d\n", s}'
}

# Git add commands
alias ga='git add'
alias gap='git add -p'
alias gaa='git add -A'
# Git commit commands
alias gc='git commit'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gcam='git commit -am'
# Git diff commands
alias gd='git diff'
alias gdw='git diff --word-diff=color'
alias gdc='git diff --cached'
alias gdcw='git diff --cached --word-diff=color'
# Git log commands (a = all, f = files, s = short)
alias gl='git log --graph --decorate'
alias glf='git log --graph --decorate --name-status'
alias gls='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias gla='git log --graph --all --decorate'
alias glaf='git log --graph --all --decorate --name-status'
alias glas='git log --graph --all --decorate --pretty=oneline --abbrev-commit'
# Git movement commands
# (cd to the root of the git repository)
alias gr='cd $(git rev-parse --show-toplevel)'
# Git status
alias gst='git status'
# Git submodule commands
alias gsup="git submodule update --init --recursive"
# Git branch commands
# shellcheck disable=SC2154 # False positive -- see https://github.com/koalaman/shellcheck/issues/2098#issuecomment-794585510
alias gban='for k in $(git branch -a --no-merged | sed s/^..//);do echo -e $(git log --color -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" "$k")\\t"$k";done|sort'
alias gbam='for k in `git branch -a --merged | sed s/^..//`;do echo -e `git log --color -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" "$k"`\\t"$k";done|sort'
# Git push commands
alias gp="git push"
alias gpnh="git push --tags nathan HEAD"
alias gpoh="git push --tags origin HEAD"

alias gocover="go test ./... -coverprofile cover.out && go tool cover -html=cover.out"
alias ij='open -a "IntelliJ IDEA"'
alias ll='ls -l'
alias lla='ls -la'
alias llh='ls -lh'
alias llah='ls -lah'
alias llrt='ls -lrt'
alias redo='clean && echo "\$ cargo run" && RUSTFLAGS="-Awarnings" cargo run'
alias rtree='tree -I target'
alias sleepnow='pmset displaysleepnow'
alias sudovim='sudo HOME=$HOME vim'
alias tclsh='rlwrap tclsh'
alias v='source venv/bin/activate && hash -r'

# Extra local config if it exists
[ -f ~/.profile-private.sh ] && source ~/.profile-private.sh

# Shell-completion for green
which green >& /dev/null && source "$( green --completion-file )"

# Shell-completion for the green stub
# zsh version
if [[ -n "$ZSH_VERSION" ]]; then
    _g_completion() {
        local word completions
        word="$1"
        case "${word}" in
            -*)
                completions="$(./g --options)"
                ;;
            *)
                completions="$(./g --completions "${word}")"
                ;;
        esac
        reply=( "${(ps:\n:)completions}" )
    }

    compctl -K _g_completion g

# bash version
elif [[ -n "$BASH_VERSION" ]]; then
    _g_completion() {
        local word opts
        COMPREPLY=()
        word="${COMP_WORDS[COMP_CWORD]}"
        opts="$(./g --options)"
        case "${word}" in
            -*)
                # shellcheck disable=SC2207,2086
                COMPREPLY=( $(compgen -W "${opts}" -- ${word}) )
                return 0
                ;;
        esac
        # shellcheck disable=SC2207
        COMPREPLY=( $(compgen -W "$(g --completions ${word} | tr '\n' ' ')" -- ${word}) )
    }
    complete -F _g_completion g
fi

# This will just end up blank if no java is installed
JAVA_HOME="$(if ls /usr/libexec/java_home &> /dev/null ; then /usr/libexec/java_home -v 1.8 2>/dev/null; fi)"
export JAVA_HOME
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Ruby environment stuff
if which rbenv &>/dev/null; then
    eval "$(rbenv init -)"
fi

# Node environment stuff
if which nodenv &>/dev/null; then
    eval "$(nodenv init -)"
fi

# Homebrew environment stuff
if [ -f "/opt/homebrew/bin/brew" ] ; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
