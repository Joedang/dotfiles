#!/bin/bash
# I would like this to become a short-ish script to generate one of those fancy
# git prompts you see in stuff like oh-my-zsh, but without the extra overhead
# or pre-configuration.

# partially implemented:
# I would like it to indicate up-to-date/unadded/uncommitted stuff using colors.
# I'm using `git status -s` to do this.
# It gives exit code zero if you're in a repo.
# It outputs stuff to stdout if there are changes.
# Examples:
## untracked changes to butts:
## ?? butts
## modified README and untracked butts:
##  M README.md
## ?? butts
## added changes:
## A  neat/gitprompt.sh
## committed changes: (no output)
## 

# unimplemented:
# I would like it to use "+n-m" to indicate ahead/behind commits. 

# fully implemented:
# I would like it to display the current branch name.

# initialize stuff
isRepo=false
gitPrompt=''

# human-readable color codes
txt_gold='\e[0;33m'
txt_red='\e[0;31m'
txt_green='\e[0;32m'
txt_reset='\e[0m'

# check if you're in a repo
if ! git status -s 1> /dev/null 2> /dev/null
then
	# not a repo
	echo Hey, this ain\'t no git repo!
	isRepo=false
else
	echo Cool, this is a git repo...
	isRepo=true
	gitPrompt=$gitPrompt`git symbolic-ref --short HEAD`
	# check if there are changes
	if [[ -z `git status -s` ]]
	then
		# no changes
		echo Darn, no changes though...
		gitPrompt=$txt_gold$gitPrompt''$txt_reset
	else
		# uncommitted changes
		echo Ooh, looky! Uncommitted changes!
		gitPrompt=$txt_red$gitPrompt'*'$txt_reset
	fi
fi

echo -e $gitPrompt
