#!/bin/bash

sudo apt install vim -y

array=(
	"vimrc"
	"vimrc.local"
	".vimrc.plug"
)

echo "INSTALL: plug.vim"
sudo curl -fLo /etc/vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

for file in ${array[@]}; do
	echo "COPY: $file"
	sudo cp ../vim/$file /etc/vim/$file
done

if [ ! -f "/etc/vim/plugged" ]; then
	echo "CHECK: plugged"
else
	echo "CREATE: plugged"
	sudo mkdir /etc/vim/plugged
fi

if [ ! -f "/etc/vim/vimplug-plugins" ]; then
	echo "CHECK: plugged"
else
	echo "CREATE: vimplug-plugins"
	sudo mkdir /etc/vim/vimplug-plugins
fi

