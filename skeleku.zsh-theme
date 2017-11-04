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


# timing code taken from this stack exchange answer:
# https://stackoverflow.com/questions/6790341/including-process-execution-time-into-shell-prompt
# ignoreTime=0.3
# function preexec() {
#     typeset -gi CALCTIME=1
#     typeset -gi startTime=SECONDS
# }
# function precmd() {
#     if (( CALCTIME )) ; then
#         typeset -gi elapsedTime=SECONDS-startTime
#     fi
#     typeset -gi CALCTIME=0
# }
timeMsg=''
# if (( elapsedTime > ignoreTime ))
# then
# 	timeMsg=' elapsed: '$elapsedTime' s
# '
# else
# 	timeMsg=''
# fi
# timeMsg='elapsed: '$elapsedTime' s'

local user_color='green'
test $UID -eq 0 && user_color='red'

PROMPT='%(?..%{$fg_bold[red]%}exit %? 
%{$reset_color%})'\
'$timeMsg'\
'%{$bold_color%}$(git_prompt_status)%{$reset_color%}'\
'$(git_prompt_info)'\
'%{$fg[$user_color]%}%~
%(!.#.$)%{$reset_color%} '

PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
