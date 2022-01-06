#!/bin/bash
# copy out the relevant dotfiles, since Windows usually doesn't support symlinks. :facepalm:
# 2018-03-08
# Joe Shields

cp -r .Renviron .Rprofile .bashrc .calcrc capsRemap.ahk .emacs .gitconfig .gitignore \
    .jupyter .profile .tmux.conf .vimrc config \
    --target-directory="$HOME"
cp .zshrc_oh-my "$HOME/.zshrc"
cp config/readline/inputrc "$HOME/.inputrc"
cp capsRemap.ahk "$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/"
mkdir -p "$HOME/.vim/bundle"
git clone https://github.com/VundleVim/Vundle.vim "$HOME/.vim/bundle/Vundle.vim"
