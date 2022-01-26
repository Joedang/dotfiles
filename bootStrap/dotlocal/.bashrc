# This file holds the local configs for this machine.
# It doesn't get committed in ~/dotfiles.

if [ -f "$HOME/.local/.bash_aliases" ]; then
    . "$HOME/.local/.bash_aliases"
fi
if [ -f "$HOME/.local/.bash_path" ]; then
    . "$HOME/.local/.bash_path"
fi
if [ -f "$HOME/.local/.bash_vars" ]; then
    . "$HOME/.local/.bash_vars"
fi
