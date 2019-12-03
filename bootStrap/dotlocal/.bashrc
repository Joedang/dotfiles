# This file holds the local configs for this machine.
# It doesn't get committed in ~/dotfiles.

if [ -f ~/.local/.bash_aliases ]; then
    . ~/.local/.bash_aliases
fi
if [ -f ~/.local/.bash_path ]; then
    . ~/.local/.bash_path
fi
if [ -f ~/.local/.bash_vars ]; then
    . ~/.local/.bash_vars
fi
