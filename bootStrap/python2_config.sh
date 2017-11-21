#!/bin/bash
echo
echo ------ upgrading pip ------
pip install --upgrade pip
echo ------ installing these Python2 packages ------
cat packages.pip2
echo ------ begining install ------
sudo -H pip install `cat packages.pip2`
echo
echo Python2 configurator is done.
echo
