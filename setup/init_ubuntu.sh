#!/bin/bash

[ $(whoami) != "root" ] && echo "Please run as root" && exit 1

INPUT=packages_ubuntu.csv
OLDIFS=$IFS
IFS=','

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read type name category url
do
	if [ "$type" == "apt" ] || [ "$type" == "snap" ]
	then
		echo "INSTALL: $name"
		sudo $type install $name

	elif [ "$type" == "deb" ]
	then
		echo "INSTALL: $name"	
	
	elif [ "$type" == "sh" ]
	then
		echo "SH: $name"
	fi

done < $INPUT
IFS=$OLDIFS

