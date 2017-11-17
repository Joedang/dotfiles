#!/bin/bash
pmi='apt install'
oldwd=`pwd`
thisShell=`ps -p $$ -ocmd=`

if [ "$thisShell" != '/bin/bash ./bootStrap.sh' ]
then
	echo shell is $thisShell
	echo must be bash, as in:
	echo 'bash ~/dotfiles/bootStrap/bootStrap.sh'
	exit 1
fi

if [ -d ~/dotfiles/bootStrap ]
then
	echo ~~~~~~ automatically changing to ~/dotfiles/bootStrap/ ~~~~~~
	cd ~/dotfiles/bootStrap
fi

if ! ls bootStrap.sh > /dev/null
then
	echo Couldn\'t find bootStrap.sh
	echo This script must be run from the same directory as bootStrap.sh
fi

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
	echo ~~~~~~ cloning dotfiles ~~~~~~
	git clone git@github.com:joedang/dotfiles.git ~/dotfiles
else
	echo ~/dotfiles already exists!
fi

if [ ! -d ~/.oh-my-zsh ]
then
	echo ~~~~~~ cloning oh-my-zsh  ~~~~~~
	git clone git@github.com:robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
else
	echo ~/.oh-my-zsh already exists!
fi

if [ ! -d ~/.vim/bundle/Vundle.vim ]
then
	echo ~~~~~~ cloning Vundle ~~~~~~
	git clone git@github.com:VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
	echo ~/.oh-my-zsh already exists!
fi

echo ~~~~~~ installing Vundle packages ~~~~~~
vim -c PluginInstall -c quit returnMsg


echo ~~~~~~ Changing default shell to zsh \(requires password\) ~~~~~~
chsh -s `which zsh`

echo ~~~~~~ unpacking dotfiles ~~~~~~
ln -s    ~/dotfiles/.zshrc_oh-my ~/.zshrc
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

echo ~~~~~~ returning to original directory ~~~~~~
cd $oldwd
