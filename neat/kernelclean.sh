#/bin/bash
# This script removes all the kernels except for the current one.
# This has only been tested under Ubuntu 14.04. In theory, it should work on any Debian-based OS. 

echo
echo Your current kernel:
uname -r | cut -f1,2 -d"-"

echo
echo Kernels to be removed:
dpkg -l linux-* | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e [0-9] | grep -E "(image|headers)"

echo
echo The removal will look something like this:
echo \(This is a dry run. Nothing is being removed yet.\)
dpkg -l linux-* | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e [0-9] | grep -E "(image|headers)" | xargs sudo apt-get --dry-run remove

echo
echo Please double check that the above information is correct, and that this will only remove the correct packages.
echo For example, if your kernel version is 3.13.0-103, then your list of \"Kernels to be removed\" should NOT
echo contain anything that mentions that number!

dpkg -l linux-* | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e [0-9] | grep -E "(image|headers)" > oldkernels.txt
echo
echo A file called oldkernels.txt has been created containing the package names related to the old kernels.
echo If everything is in order, run \'echo oldkernels.txt \| xargs sudo apt-get -y purge\'
