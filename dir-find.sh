#! /bin/bash

if [[ $# < 1 ]]; then
	echo "Usage: $0 directory|link <directory>"
	# exit 1
fi

case $1 in
	"directory")
		find $2 -maxdepth 1 -type d
		;;
	"link")
		find $2 -maxdepth 1 -type l
		;;
	*)
		echo "Usage: $0 directory|link <directory>"
		#exit 1
esac