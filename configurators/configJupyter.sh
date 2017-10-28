#!/bin/bash
echo ----- starting jupyter configurator -----
echo ----- installing jupyter -----
pip install jupyter
pip install --upgrade notebook
echo ----- adding extensions -----
pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
echo ----- adding the dark theme -----
pip install jupyterthemes
jt -t onedork -T
OLDDIR=`pwd`
cd $(jupyter --data-dir)
mkdir nbextensions
cd nbextensions/
echo ----- adding vim bindings -----
git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding
chmod -R go-w vim_binding
cd $OLDDIR
echo ----- enabling vim bindings -----
jupyter nbextension enable vim_binding
echo ----- enabling folding -----
jupyter nbextension enable codefolding
echo ----- jupyter configurator done -----
