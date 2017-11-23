#!/bin/bash
# modelled after this TeX stack exchange answer:
# https://tex.stackexchange.com/questions/1092/how-to-install-vanilla-texlive-on-debian-or-ubuntu

# to remove this install, do
# `sudo rm -rf /usr/local/texlive`
# `sudo apt purge texlive-local`
# This stack exchange answer may also provide a more exhaustive uninstall:
# https://tex.stackexchange.com/questions/95483/how-to-remove-everything-related-to-tex-live-for-fresh-install-on-ubuntu/95502#95502


echo
echo ------ starting LaTeX configurator ------
echo

oldwd=`pwd`
tmpdir='/tmp/latex_config'
tldownload='http://mirror.ctan.org/systems/texlive/tlnet/'
tlzip='install-tl-unx.tar.gz'
equivsPackage='https://www.tug.org/texlive/files/debian-equivs-2017-ex.txt'
tlYear=2017

echo
echo !----- Using the $tlYear equivalent package -----!
echo If a newer version of tlmgr is available, you should update the 
echo URL and year in this script.
read -n 1 -p "Continue with $tlYear? [y/N]" answer
if [ ! $answer == 'y' ]
then
	echo Okay, exiting...
	exit 2
fi

echo
echo ------ cleaning out temp directory ------
rm -rf $tmpdir
mkdir $tmpdir

echo ------ installing dependencies for LaTeX ------
if [ ! -f latex_depend.apt ]
then
	echo !----- It looks like you\'re in the wrong directory... -----!
	exit 1
fi
cat latex_depend.apt
sudo apt-get install `cat latex_depend.apt`

echo ------ downloading TeXLive installer ------
wget $tldownload$tlzip -P $tmpdir/ --progress=bar

echo ------ extracting installer ------
tar -xzf  --checkpoint 100
tar -xzf $tmpdir/$tlzip --checkpoint=100 -C $tmpdir
cd "$tmpdir"/install-tl-*

echo ------ running installer ------
sudo ./install-tl

echo ------ installer finished------
echo Please check that you have the correct things in your path.
echo '(Look at ~/dotfiles/.bash_path and `which pdflatex` or `which tex`)'

echo ------ installing equivs ------
sudo apt-get install equivs --no-install-recommends
mkdir -p $tmpdir/tl-equivs 
cd $tmpdir/tl-equivs
equivs-control texlive-local

echo ------ creating equivalent package ------
echo '(This makes a pretend package, so that dpkg knows you have tlmgr and friends installed.)'
cd $tmpdir
wget $equivsPackage

echo ------ building equivs package -------
equivs-build texlive-local

echo ------ installing equivs package ------
sudo dpkg -i texlive-local*.deb

echo ------ fixing any broken dependencies ------
sudo apt-get install -f

echo ------ making launcher shortcut ------
mkdir -p ~/.local/share/applications
cd $oldwd
cp tlmgr.desktop ~/.local/share/applications/

echo ------ returning to old directory ------
cd $oldwd
