#!/bin/bash
pmi='apt install'

echo ~~~~~~ UPDATING APT REPOS ~~~~~~
sudo apt update
echo ~~~~~~ UPGRADING INSTALLED PACKAGES ~~~~~~
sudo apt upgrade
echo ~~~~~~ UPGRADING DISTRO ~~~~~~
sudo apt-get dist-upgrade
echo ~~~~~~ installing useful packages ~~~~~~
cat packages.apt
sudo apt install `cat packages.apt`

read -n 1 -p 'Copy ssh keys from Joe-ThinkPad? (must be on local network) (y/n)' answer
if [ $answer == 'y' ]
then
	echo Compare this to the fingerprint on the host machine, using 
	echo ssh-keygen -lf /etc/ssh/ssh_host_ecdsa_key
	echo \(In the \'future\' it may be something other than ECDSA,
	echo and the host machine may have a version of ssh-keygen that 
	echo supports something other than MD5 fingerprints. So, you may 
	echo need to modify this script/command accordingly.\)
	echo Unless I\'ve changed the key, it should be:
	echo MD5:2f:43:12:29:77:f5:8e:b2:e9:74:ef:1b:f4:f3:8b:a9
	scp -o FingerprintHash=md5 joedang@Joe-ThinkPad:~/.ssh/* ~/.ssh*
else
	echo Okay, skipping...
fi

if [ ! -d ~/dotfiles ]
then
	git clone git@github.com:joedang/dotfiles.git ~/dotfiles
else
	echo ~/dotfiles already exists!
fi

if [ ! -d ~/.oh-my-zsh ]
then
	git clone git@github.com:robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
else
	echo ~/.oh-my-zsh already exists!
fi

echo Changing default shell to zsh \(requires sudo\)...
sudo chsh -s zsh
ln -st ~ ~/dotfiles/.zshrc_oh-my ~/.zshrc
ln -st ~ ~/dotfiles/.bashrc
ln -st ~ ~/dotfiles/.vimrc
ln -st ~ ~/dotfiles/.tmux.conf
ln -st ~ ~/dotfiles/.Renviron
ln -st ~ ~/dotfiles/.Rprofile
ln -st ~ ~/dotfiles/.profile
ln -st ~ ~/dotfiles/.jupyter
ln -st ~ ~/dotfiles/.gitconfig
ln -st ~ ~/dotfiles/.emacs
ln -st ~ ~/dotfiles/.calcrc
ln -st ~ ~/dotfiles/bin
