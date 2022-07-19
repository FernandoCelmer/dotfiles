#!/bin/bash

array=(
        "Konsole.colorscheme"
        "Konsole.profile"
)

for file in ${array[@]}; do
        echo "COPY: $file"
        sudo cp ../terminal/$file ~/.local/share/konsole/$file
done

echo "APPLY: Terminal"
konsoleprofile colors=Konsole
