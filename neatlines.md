# This is a little gallery of neat one-liners I've done.

## Get the number of pages in all the PDFs in the CWD:

    ls *.pdf | awk -e '{print "pdfgrep -n [:alphanum:] "$1"| tail -1"}' | sh

Pipe the names of the PDFs to awk. 
Use awk to build those into a command which:
	* uses pdfgrep to search that PDF for lines with any alphanumeric character, prepending the line number
	* pipe the results to tail, which cuts out all but the last result
Send that command to the shell.

This doesn't tell you the file names, and also outputs the text on the last line of each PDF :(

## disable auto-mounting 
My hope is that this is an easy way to thwart usb attacks.

Using dconf-editor, under `org.gnome.desktop.media-handling`, uncheck `automount` and optionally `automount-open`.

To do this without a GUI, you'd do
`gsettings set org.gnome.desktop.media-handling automount false`.

Both of these are frontents for `dconf`.
