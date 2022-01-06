# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# TODO: clean out the cruft; genericize the references to certain paths?; improve readability

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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

# turn on colored prompt
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

_exitstatus() {
    status=$?
    (( status != 0 )) && printf "\001\e[1;31m\002exit $status\n\001\e[0m\002"
}
PROMPT_COMMAND=_exitstatus

#PS1='$(_exitstatus)\[\e[32m\]\w\[\e[0m\]\n\e[32m\s➔\e[0m '
PS1='\[\e[32m\]\w\[\e[0m\]\n\e[32m\s➔\e[0m '
#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\033[1;32m\$\033[22;39m '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Aliases and path munging
# These things are kept in separate files, to keep everything clean.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
test -f "$HOME/.config/dotfiles/dotfiles.conf" && . "$HOME/.config/dotfiles/dotfiles.conf"
test -z "$DOTFILES_DIR" && DOTFILES_DIR="$HOME/dotfiles"

if [ -f "$DOTFILES_DIR/.bash_aliases" ]; then
    . "$DOTFILES_DIR/.bash_aliases"
fi
if [ -f "$DOTFILES_DIR/.bash_path" ]; then
    . "$DOTFILES_DIR/.bash_path"
fi
if [ -f "$DOTFILES_DIR/.bash_vars" ]; then
    . "$DOTFILES_DIR/.bash_vars"
fi
if [ -f "~/.local/.bashrc" ]; then
    . "~/.local/.bashrc"
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

if [[ -f "~/TODO.md" ]]; then
# 	pandoc ~/TODO.md -t html | lynx -stdin -dump
	echo "There are $(wc -l "~/TODO.md" | grep -o '[0-9]*\ ')lines remaining in ~/TODO.md!"
fi
# w2do -l
