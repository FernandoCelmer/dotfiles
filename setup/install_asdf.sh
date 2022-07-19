#!/bin/bash

sudo git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

echo "" >> ~/.bashrc
echo "# ASDF" >> ~/.bashrc
echo ". ""$""HOME/.asdf/asdf.sh" >> ~/.bashrc
echo ". ""$""HOME/.asdf/completions/asdf.bash" >> ~/.bashrc

# PYTHON
echo "INSTALL: Python"
asdf plugin-add python
#asdf install python 2.7.18
#asdf install python 3.6.12
echo "=========="

# NODEJS
echo "INSTALL: NodeJS"
asdf plugin-add nodejs
#asdf install nodejs 12.10.0
#asdf install nodejs 14.16.0
#asdf install nodejs 16.14.2
echo "=========="
