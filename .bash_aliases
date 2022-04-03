#!/bin/bash
# This should be source-able from any POSIX shell.
# vim: foldmethod=marker:

# some navigation aliases {{{
## colored output for core stuff {{{
if [ -x /usr/bin/dircolors ]; then # colored printing of directory contents
    test -r "~/.dircolors" && eval "$(dircolors -b "~/.dircolors")" || eval "$(dircolors -b)"
fi
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
## }}}

alias clear='clear -x' # don't attempt to empty the scrollback buffer
alias cls='clear; ls'
alias clsd='clear; lsd'
#alias ll='ls -alFh'
alias ll='echo "\e[36mflags,   refs,owner, group, size,  modified, name\e[39m" ; ls -alFh'
alias lth='ls -lth | head'
alias la='ls -a'
alias lla='ls -la'
alias l='ls -CF'
alias lsd='ls -d -- */'
alias cj='clear; jobs'
alias clj='clear; jobs; ls'
alias pl='pwd;ls'
function cdls() { 
    cd "$@"; ls; 
}
alias chonkers='du -hd1 * | sort -hr | head' # show the chonky dirs that take up a lot of space
alias path='echo -e "${PATH//:/\\n}"'

# Clear the screen, go to the home dir, say the user and host name, list any running jobs, list dir contents 
alias home='clear; cd "$HOME"; env echo -e "\e[36m$(whoami)"\@$(uname -n)"\e[35m";jobs; env echo -en "\e[39m"; ls'
alias hoe="home; echo 'What did you just call me?!'"
# }}}
# stuff for surviving Windows {{{
function lslnk() {
    # extract a string of printable characters starting like C:\ or D:\ et cetera
    cygpath.exe "$(grep -aoe '[[:upper:]]:\\[[:print:]]*' "$1")"
}
function cdlnk() { # follow a windows shortcut
    cd "$(lslnk "$*")"
}
if [[ "$WINCOMPATABILITY" == "MINGW" ]]; then # git bash
    #alias notify-send='ahk-notify-send'
elif [[ "$WINCOMPATABILITY" == "WSL" ]]; then # WSL
    #alias notify-send='ahk-notify-send'
else # real Linux
fi
function mklnk() { # create a windows shortcut
    # Take advantage of AutoHotkey's ability to make Windows shortcuts... because there's no good builtin way!
    # https://i.kym-cdn.com/photos/images/original/000/889/900/492.gif
    # TODO: make this work cleanly on WSL. (Currently, wslpath sucks because it errors-out when given a fictional path... which I need to do for the link path.)
    targetPath="$1"
    linkPath="$2"
    [[ -z "$linkPath" ]] && linkPath="$(basename "$targetPath").lnk" # if no link name given, behave like ln -s
    winTargetPath=$(cygpath.exe -w "$targetPath")
    winLinkPath=$(cygpath.exe -w "$linkPath")

    echo "FileCreateShortcut,%A_WorkingDir%\\$winTargetPath,$winLinkPath" | "$AHKEXE" '*'
}
# }}}
# git aliases that are hard to build into .gitconfig {{{
alias sta='git status'
alias githome='cd "$(git rev-parse --show-toplevel)"'
alias allsta=' find . -type d -name "\.git" \
				-execdir pwd \; \
				-execdir git status -sb \; \
				-execdir echo -e \\n \;' # get the status of every git subdirectory
# }}}
# miscellaneous abreviated aliases {{{
infind() {
    # use find to fuzzy match a word in the current directory
	find -iname "*$1*"
}
inlocate() {
    # use locate to fuzzy match a word in the current directory
    # This is like an order of magnitude faster, but the database only gets updated when the cron job runs.
    locate -i "$(pwd)/*$1*"
}
alias vl='/usr/share/vim/vim74/macros/less.sh'
alias gcalc='gcalccmd'
alias trash='gvfs-trash' # TODO: figure out how to use the trash on Arch
alias trashls='gvfs-ls trash://'
alias xop='xdg-open'
alias iR='jupyter console --kernel ir'
alias R='R --no-save' # this is simpler than putting a wrapper around q() in .Rprofile
alias histless='history | less'
alias pyserve2='python2 -m SimpleHTTPServer'
alias pyserve3='python3 -m http.server'
alias jsync='nice -n 10 rsync -a --partial --inplace --info=progress2'
alias pingg='ping google.com'
alias audio-dl='youtube-dl -f '\''bestaudio'\'
alias batteryPercent='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -P '\''(?<=\s)[0-9]*%'\'
alias cath='highlight --out-format ansi'
alias qmv='qmv -o spaces'
alias j2a='jp2a --colors --background=dark'
alias fp='firefox --private'
alias norename='tmux set-window-option allow-rename off'
alias xclip='xclip -selection clipboard'
alias winclipcopy='/mnt/c/Windows/system32/clip.exe'
alias winclippaste='/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c Get-Clipboard'
alias psudo='sudo env PATH="$PATH"' # "path sudo" Use sudo with your current PATH.
alias ssay='spd-say'
# default to vi-like key bindings for given programs
alias info='info --vi-keys'
#alias lynx='lynx --vikeys --use_mouse --enable_scrollback' # handled in lynx.cfg now
alias facecam='mpv --profile=low-latency --vf=hflip --geometry=20%x20%-5-25 /dev/video0'
alias nmpc='ncmpcpp'
quicklog() {
    QUICKLOG="$HOME/log/quick.log"
    date -Iseconds >> "$QUICKLOG"
    printf "$*\n" >> "$QUICKLOG"
}
alias ql='quicklog'
# show quicklog entries from today and yesterday:
alias qlc='cat "$HOME/log/quick.log" | grep -A 100 --color=never -e $(date -Idate) -e $(date -Idate -d yesterday)'
alias scrot-box="scrot -sfl style=dash,color=red -e 'mv \$f ~/img/capture/; xclip -selection clipboard -t image/png ~/img/capture/\$f'"
alias scrot-full="scrot -e 'mv \$f ~/img/capture/'"
alias spellcheck="look"
alias xinfo="echo Actually, it\\'s called xprop.; xprop"
alias shazam="echo Actually it\\'s called kazam.; kazam"
alias lockScreen='i3lock -i "$HOME/img/lock" --show-failed-attempt'
alias mansplain="man"
alias et="exiftool"
hlview() {
    lynx <(source-highlight -i "$*" -o STDOUT) -force_html
}
# }}} 
# things to control the encrypted journal {{{
alias jrnl-mount="encfs $XDG_DOCUMENTS_DIR/.journal $XDG_DOCUMENTS_DIR/journal"
alias jrnl-umount="fusermount -u $XDG_DOCUMENTS_DIR/journal && df | grep $XDG_DOCUMENTS_DIR/journal | sed 's/^.*$/Seemingly failed to unmount journal./'"
alias jrnl='jrnl-mount; vim $XDG_DOCUMENTS_DIR/journal/`date -I`.md; jrnl-umount'
# }}} 
# reference material {{{
alias chrestomathy="vim $DOTFILES_DIR/chrestomathy.md"
alias colorRef='cat <(colorCodes) <(colorBlocks) | less'
ddg() {
    lynx "https://lite.duckduckgo.com/lite/?q=$@"
}
alias search='ddg'
# }}} 
# silly ASCII things {{{
alias gf='echo TFW no gf; fg'
alias zoidberg="cat $DOTFILES_DIR/neat/zoidberg.txt"
alias drop="ogg123 ~/audio/samples/dropIt.ogg 2> /dev/null & cat $DOTFILES_DIR/neat/dropTheBass.txt"
alias gnuLinux="cat $DOTFILES_DIR/neat/gnuLinux.txt"
# Count the empty lines in faces.txt. Pick a random one. Print everything after that, until the next empty line.
alias face='awk -v r=$(( $RANDOM % ($(egrep -c '\''^$'\'" $DOTFILES_DIR/neat/faces.txt) +1) )) 'BEGIN{n=0}/^$/{n++;next}{if(n==r)print}' $DOTFILES_DIR/neat/faces.txt" # print a random face
alias lenny="echo '( ͡° ͜ʖ ͡°)'"
alias wut="echo 'ಠ_ಠ'"
alias rainbowClock='watch -t -n1 --color _rainbowHelper'
gayman() {
    man $1 | toilet --gay -f term -w $(tput cols) | less
}
# }}} 
# Uncategorized {{{
alias mouseWiggler='watch -n 240 "xdotool mousemove 50 50 mousemove restore"'
alias peppyCaps='~/.xkb/recomp.sh'
alias soundCheck='find ~/audio/samples -maxdepth 1 -type f | sort -R | head -n 1 | xargs play'
alias chungus='play ~/audio/samples/bigChungus.ogg'
alias ptsc='xfce4-screenshooter -fs ~/img/capture/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png'

# Add an "alert" alias for long running commands.  Use like so: `sleep 10; alert`
# This is obsolete when my oh-my-zsh profile is in effect.
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# alias tmux='tmux -2' # This should be done in the local config.
# alias bgshuffle='xfdesktop --next'
#alias viewmd='function _viewmd(){ pandoc -i "$1" -o /tmp/$(basename ${1%.*}.html); chromium-browser /tmp/$(basename ${1%.*}.html); };_viewmd'

# }}}
