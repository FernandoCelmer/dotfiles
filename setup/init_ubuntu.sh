#!/bin/bash

INPUT=packages_ubuntu.csv
OLDIFS=$IFS
IFS=','

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read type name category url
do
	if [ "$type" == "APT" ]
	then
		echo "APT: $name"

   	elif [ "$type" == "SNAP" ]
	then
		echo "SNAP: $name"

	elif [ "$type" == "DEB" ]
	then
		echo "DEB: $name"	
	
	elif [ "$type" == "SH" ]
	then
		echo "SH: $name"
	fi

done < $INPUT
IFS=$OLDIFS

