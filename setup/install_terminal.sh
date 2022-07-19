#!/bin/bash

DIR="/home/fernandocelmer"

array=(
        "Konsole.colorscheme"
        "Konsole.profile"
)

for file in ${array[@]}; do
        echo "COPY: $file"
        sudo cp ../terminal/$file $DIR/.local/share/konsole/$file
done
