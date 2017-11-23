#!/bin/bash
echo
echo ------ upgrading pip3 ------
pip3 install --upgrade pip
echo ------ installing these python3 packages ------
cat packages.pip3
echo ------ begining install ------
sudo -H pip3 install `cat packages.pip3`
echo
echo Python3 configurator is done.
echo
