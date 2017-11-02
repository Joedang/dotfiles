#!/bin/bash
# enable color support of ls and friends. Also add handy aliases.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear; ls'
alias clsd='clear; lsd'
alias lsd='ls -d -- */'
alias pl='pwd;ls'

# git aliases that are hard to build into .gitconfig
alias sta='git status'
alias githome='cd "$(git rev-parse --show-toplevel)"'

# Add an "alert" alias for long running commands.  Use like so: `sleep 10; alert`
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# default to vi-like key bindings for given programs
alias info='info --vi-keys'
alias lynx='lynx --vikeys'

#alias viewmd='function _viewmd(){ pandoc -i "$1" -o /tmp/$(basename ${1%.*}.html); chromium-browser /tmp/$(basename ${1%.*}.html); };_viewmd'

# miscellaneous abreviated aliases
alias gcalc='gcalccmd'
alias trash='gvfs-trash'
alias trashls='gvfs-ls trash://'
alias xop='xdg-open'
# function linfo { info $@ | less; }
alias todo='w2do'
alias iR='jupyter console --kernel ir'
alias hist='history'
