#!/bin/bash
convert -density 600 -background white -flatten -alpha off $1 "${1%.pdf}".png
