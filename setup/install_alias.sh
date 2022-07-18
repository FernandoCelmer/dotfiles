#!/bin/bash

FILE=~/.bash_aliases

create_alias() {
	array=(
		"alias activate='source venv/bin/activate'"
		"alias act='source venv/bin/activate'"
		"alias gch='python ~/.scripts/script_checkout_branch.py'"
		"alias gcm='python ~/.scripts/script_commit_branch.py'"
		"alias gcr='python ~/.scripts/script_create_branch.py'"
		"alias gde='python ~/.scripts/script_delete_branch.py'"
		"alias gme='python ~/.scripts/script_merge_branch.py'"
		"alias pservedev='pserve --reload development_ubuntu.ini'"
		"alias pserveprod='pserve --reload production_ubuntu.ini'"
		"alias runserver='python manage.py runserver'"
		"alias venv27='virtualenv -p python2.7 venv'"
		"alias venv36='virtualenv -p python3.6 venv'"
		"alias venv39='virtualenv -p python3.9 venv'"
		"alias gitsetname='git config --local user.name FernandoCelmer'"
		"alias gitsetemail='git config --local user.email email@fernandocelmer.com'"
		"alias gitnamecake='git config --local user.name Fernando Henrique de Oliveira Celmer'"
		"alias gitemailcake='git config --local user.email fernando.celmer@cakeerp.com'"
		"alias gitname='git config --local user.name'"
		"alias gitemail='git config --local user.email'"
	)
	echo "" >> $FILE
	for ali in ${!array[@]}; do
		echo "${array[$ali]}" >> $FILE
	done

}

if [ -f "$FILE" ]; then
	sudo rm -r ~/.bash_aliases
	create_alias
else 
	create_alias
fi

