#!/bin/bash
for FILE in /tmp/orb*.pdf
do
	RAWNAME=${FILE%.pdf}
	echo converting $RAWNAME from PDF to JPG
	convert "$RAWNAME".pdf "$RAWNAME".jpg
done
echo converting JPG to GIF
convert -delay 0.5 /tmp/orb*.jpg ./orb.gif
cp orb.gif ~/Downloads
