# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# If it's downloaded, use the bash-git-prompt when in a git repo
# Not usable until I find out how to keep it from slowing down the prompt so much
# if [ -f ".bash-git-prompt/gitprompt.sh" ]; then
# 	source ~/.bash-git-prompt/gitprompt.sh
# 	GIT_PROMPT_ONLY_IN_REPO=1
# 	GIT_PROMPT_SHOW_UNTRACKED_FILES=no
# fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## add OpenFoam tools to the path
#. /opt/openfoam30/etc/bashrc
## correcting doubled-up commands
# alias R='/usr/bin/R'
# alias foamR='/opt/openfoam30/platforms/linux64GccDPInt32Opt/bin/R'

CALCRC='~/.calcrc'
export CALCRC

if [[ -f ~/TODO.md ]]; then
# 	pandoc ~/TODO.md -t html | lynx -stdin -dump
	echo "There are $(wc -l ~/TODO.md | grep -o '[0-9]*\ ')lines remaining in ~/TODO.md!"
fi
# w2do -l

#User defined aliases
#alias R='. /usr/local/bin/R'
alias sta='git status'
alias githome='cd "$(git rev-parse --show-toplevel)"'
alias pl='pwd;ls'
alias lsd='ls -d -- */'
alias infovi='info --vi-keys'
alias lynxvi='lynx --vikeys'
#alias viewmd='function _viewmd(){ pandoc -i "$1" -o /tmp/$(basename ${1%.*}.html); chromium-browser /tmp/$(basename ${1%.*}.html); };_viewmd'
alias cls='clear; ls'
alias clsd='clear; lsd'
alias gcalc='gcalccmd'
alias trash='gvfs-trash'
alias trashls='gvfs-ls trash://'
alias xop='xdg-open'
# function linfo { info $@ | less; }
alias vinfo='info --vi-keys'
alias todo='w2do'
alias iR='jupyter console --kernel ir'

# add tlmgr to the PATH
# unclear if this is still necessary
# also add ~/bin
PATH=/usr/local/texlive/2016/bin/x86_64-linux:$PATH
PATH=~/bin:$PATH
# PATH=/opt/android-studio/bin:$PATH
PATH=/usr/local/brlcad/bin:$PATH
PATH=/usr/local/julia/bin:$PATH
PATH=~/.local/bin:$PATH
PATH=/usr/local/datcom_plus/bin:$PATH
PATH=/usr/sbin:$PATH
PATH=/sbin:$PATH
if [[ "hostname"=='localhost' ]]; then
	# If on the chromebook, add the Ruby install that's in
	# my home dir to my path.
	PATH=/home/joedang/src/Ruby/bin/:$PATH;
fi
export PATH

