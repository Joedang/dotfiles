#!/bin/bash
PAGES=$(pdfinfo $1 | grep "Pages:" | grep -Eo '[0-9]')
for pg in ${1..PAGES}
do
	echo "page number $pg\n"
done
