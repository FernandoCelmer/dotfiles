#!/bin/bash

[ $(whoami) != "root" ] && echo "Please run as root" && exit 1

INPUT=packages_ubuntu.csv
OLDIFS=$IFS
IFS=','

sudo apt update -y
sudo apt upgrade -y

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read type name category url file
do
	if [ "$type" == "apt" ]
	then
		echo "INSTALL: $name"
		sudo $type install $name -y
		echo "=========="

	elif [ "$type" == "snap" ]
	then
		echo "INSTALL: $name"
		sudo $type install $name
		echo "=========="

	elif [ "$type" == "deb" ]
	then
		INSTALL: $name
		wget $url
		sudo dpkg -i $file
		sudo apt install -f
		sudo rm -r $file
		echo "=========="
	
	elif [ "$type" == "sh" ]
	then
		echo "INSTALL: $name"
		sudo chmod 777 $file
		sudo ./$file
		echo "=========="
	fi

done < $INPUT
IFS=$OLDIFS

