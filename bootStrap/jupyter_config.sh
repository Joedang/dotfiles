#!/bin/bash
echo ----- starting jupyter configurator -----
echo ----- installing jupyter -----
pip3 install jupyter
pip3 install --upgrade notebook
echo ----- adding extensions -----
pip3 install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
echo ----- adding the dark theme -----
pip3 install jupyterthemes
jt -t onedork -T -vim
OLDDIR=`pwd`
echo ----- adding vim bindings -----
cd $(jupyter --data-dir)
mkdir nbextensions
cd nbextensions/
git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding
chmod -R go-w vim_binding
cd $OLDDIR
echo ----- enabling vim bindings -----
jupyter nbextension enable vim_binding
echo ----- enabling folding -----
jupyter nbextension enable codefolding

echo ----- installing R kernel for Jupyter -----
R -e 'install.packages("devtools", repos="https://ftp.osuosl.org/pub/cran");devtools::install_github("IRkernel/IRkernel");IRkernel::installspec()'

echo ----- installing Python2 kernel for Jupyter -----
sudo -H pip install -U ipykernel
python2 -m ipykernel install

echo ----- jupyter configurator done -----
