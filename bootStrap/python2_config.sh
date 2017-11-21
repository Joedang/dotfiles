#!/bin/bash
echo
echo ------ installing these Python2 packages ------
cat packages.pip2
echo ------ begining install ------
sudo pip install `cat packages.pip2`
echo
echo Python2 configurator is done.
echo
