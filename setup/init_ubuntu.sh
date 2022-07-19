#!/bin/bash

[ $(whoami) != "root" ] && echo "Please run as root" && exit 1

INPUT=packages_ubuntu.csv
OLDIFS=$IFS
IFS=','

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read type name category url
do
	if [ "$type" == "apt" ]
	then
		echo "INSTALL: $name"
		sudo $type install $name -y
	
	elif [ "$type" == "snap" ]
	then
		echo "INSTALL: $name"
		sudo $type install $name

	elif [ "$type" == "deb" ]
	then
		echo "INSTALL: $name"	
	
	elif [ "$type" == "sh" ]
	then
		echo "INSTALL: $name"
		sudo chmod 777 $url
		sudo ./$url
	fi

done < $INPUT
IFS=$OLDIFS

