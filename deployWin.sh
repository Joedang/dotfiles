#!/bin/bash
# copy out the relevant dotfiles, since Windows usually doesn't support symlinks. :facepalm:
# 2018-03-08
# Joe Shields
scriptPath="$(pwd)/$0"
echo "path to this script: $scriptPath"
dotDir="$(dirname "$scriptPath")"
echo "dotDir: $dotDir"
startingDir="$(pwd)"
echo "startingDir: $startingDir"
if [[ "$HOME" =~ ' ' ]]; then
    echo Your home directory has spaces in its path.
    echo That\'s going to cause a world of pain.
    echo You *REALLY* should do something about that!
    echo "\$HOME: $HOME"
fi

cp .zshrc_oh-my "$HOME/.zshrc"
cp config/readline/inputrc "$HOME/.inputrc"
cp capsRemap.ahk bindings.ahk     "$APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/"
#create-shortcut.exe capsRemap.ahk "$APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/"
#create-shortcut.exe bindings.ahk  "$APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/"
mkdir -p "$HOME/.vim/bundle"
git clone https://github.com/VundleVim/Vundle.vim "$HOME/.vim/bundle/Vundle.vim"

# array of filenames that should be copied to $HOME
homeDots=( .bashrc .calcrc .emacs .gitconfig .gitignore .jupyter .profile .Renviron .Rprofile .tmux.conf .vimrc )
# echo $homeDots | sed "s/\([.[:graph:]]*\)/$dotDir\/\1/g"
for f in "${homeDots[@]}"; do
    cp -r "$dotDir/$f" --target-directory="$HOME"
done
cp .zshrc_oh-my "$HOME/.zshrc"
cp config/readline/inputrc "$HOME/.inputrc"

cp -r config "$HOME/.config" # copy the stuff bundled in config/
mkdir -p "$HOME/.config/dotfiles"

# set the location of the dotfiles repo
test -z "$DOTFILES_DIR" \
    && echo "export DOTFILES_DIR='$dotDir'" >> "$HOME/.config/dotfiles/dotfiles.conf"

# setup stuff for persistent ssh-agent
mkdir -p "$HOME/log"
touch "$HOME/log/ssh-agent-track.log"

# TODO: this stuff may need to be a PowerShell script. *vomits a little*
# - copy capsRemap to startup folder?
# - copy capsRemap to start menu folder?
# - pin things to taskbar?
# - install things via Windows package manager?

echo You\'re gonna want to install these:
echo 'Git for Windows: https://git-scm.com/download/win'
echo 'Autohotkey: https://www.autohotkey.com/download/ahk-install.exe'
echo 'Greenshot: https://getgreenshot.org/downloads/'
echo 'Inkscape: https://inkscape.org/'
echo 'VcXsrv: https://sourceforge.net/projects/vcxsrv/'
