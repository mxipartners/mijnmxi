#!/bin/sh
shopt -s nullglob
for i in ../public/images/*.svg; do
	mv "$i" "$i.orig"
	./convert_svg.sh "$i.orig" > "$i"

	# On error restore original
	if [ $? -ne 0 ]; then
		mv "$i.orig" "$i"
	fi
done
