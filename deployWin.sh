#!/bin/bash
# copy out the relevant dotfiles, since Windows usually doesn't support symlinks. :facepalm:
# 2018-03-08
# Joe Shields

 cp -r .Renviron .Rprofile .bashrc .calcrc .gitconfig \
	 .gitignore .profile .tmux.conf .vimrc bin \
	 --target-directory="$HOME"
