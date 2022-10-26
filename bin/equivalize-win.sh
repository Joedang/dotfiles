#!/bin/bash
# wrapper for equivalize on Windows

# grab a string from the user
#equivInput=$(ahk $'InputBox, equivInput,, "text to equivalize: "\nFileAppend, %equivInput%, *')
# Waiting for AHK to open an input window is TOO SLOW!
# It's much faster to just use the Bash window, lmao... still not fast enough to keep up with USER INPUT(!?) the way dmenu does. :eyeroll:
read -p 'text to equivalize: ' equivInput

# equivalize it and copy it to the clipboard
# TODO: figure out the compatability shenanigans to get this to form the correct path for both mintty and WSL (currently works for mintty)
equivalize "$equivInput" | "/c/Windows/System32/clip.exe"
