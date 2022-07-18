git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

echo "" >> ~/.bashrc
echo "# ASDF" >> ~/.bashrc
echo ". ""$""HOME/.asdf/asdf.sh" >> ~/.bashrc
echo ". ""$""HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
