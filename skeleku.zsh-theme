#!/usr/bin/zsh
# Git-centric variation of the "fishy" theme.
# See screenshot at http://ompldr.org/vOHcwZg

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}A,"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[magenta]%}M,"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}rm,"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}mv,"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}#,"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}?,"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""


# timing code inspired by this stack exchange answer:
# https://stackoverflow.com/questions/6790341/including-process-execution-time-into-shell-prompt
# How preexec() and precmd() work:
# This is precmd().
# ~
# $ echo asdf
# This is preexec().
# asdf
# This is precmd().
# ~
# $
ignoreTime=10 # seconds, only echo elapsed time if commands are longer than this
notifyTime=60 # seconds, only send notifications if commands are longer than this
omzsh_noSayPattern='^vim\|^less\|^man\|^info\|^hist\|^fg' # commands (patterns) to never time
omzsh_sayTime_global='y' # do you want to report execution times? (y/n)

unset omzsh_startTime

function preexec() {
    # echo 'This is preexec().'
    # typeset -gi CALCTIME=1
    # typeset -gi startTime=SECONDS
    omzsh_startTime=`date +%s.%N`
    omzsh_thisCmd=`tail -n 1 ~/.zsh_history`
    omzsh_sayTime=$omzsh_sayTime_global
    omzsh_sayTimeSearch=`echo ${omzsh_thisCmd##*;} | grep $omzsh_noSayPattern`
    if [ "$omzsh_sayTimeSearch" != '' ] 
    then # it's a command that I don't want to time
	    omzsh_sayTime='n'
    fi
}

function precmd() {
    # echo 'This is precmd().'
    # check to see if a start time was set.
    if (( ${+omzsh_startTime} ))
    then # A start time was set.
	omzsh_stopTime=`date +%s.%N`
	omzsh_diffTime=`echo $omzsh_stopTime - $omzsh_startTime | bc`
	omzsh_diffTime=`printf '%0.1f\n' $omzsh_diffTime`
	omzsh_timeMsg=`echo $fg[red]$omzsh_diffTime s`
	if [ $omzsh_sayTime = 'y' ] && [ `echo $omzsh_diffTime '>' $ignoreTime | bc` -eq 1 ]
	then
	    echo $omzsh_timeMsg
	    if [ `echo $omzsh_diffTime '>' $notifyTime | bc` -eq 1 ]
	    then
		notify-send "long command done" "$omzsh_diffTime s"
	    fi
	fi
    fi
}

local user_color='green'
test $UID -eq 0 && user_color='red'

PROMPT='%(?..%{$fg_bold[red]%}exit %? 
%{$reset_color%})'\
'$timeMsg'\
'%{$bold_color%}$(git_prompt_status)%{$reset_color%}'\
'$(git_prompt_info)'\
'%{$fg[$user_color]%}%~
%{$bold_color%}%(!.#.$)%{$reset_color%} '

PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
