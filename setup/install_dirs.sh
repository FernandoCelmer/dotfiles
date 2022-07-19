#!/bin/bash

DIR="/home/fernandocelmer"

create_dirs() {
	array=(
		".ssh"
		".aws"
		".scripts"
		"Documents/Projects"
		"Documents/Tests"
		"Documents/Github"
	)

	for ali in ${!array[@]}; do
		FILE="$DIR/${array[$ali]}"

		if [ -f "$FILE" ]; then
			sudo mkdir $FILE
		else 
			echo "CHECK: $FILE"
		fi
	done

}

create_dirs
