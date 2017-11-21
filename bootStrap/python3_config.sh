#!/bin/bash
echo
echo ------ installing these python3 packages ------
cat packages.pip3
echo ------ begining install ------
sudo pip3 install `cat packages.pip3`
echo
echo Python3 configurator is done.
echo
