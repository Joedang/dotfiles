#/bin/bash
for f in *
do
	git mv $f $(echo $f | sed -e 's/:/-/g')
done
