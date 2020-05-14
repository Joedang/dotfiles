#!/bin/bash
# This should be source-able from any POSIX shell.

# colored output for core stuff
if [ -x /usr/bin/dircolors ]; then # colored printing of directory contents
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some navigation ls aliases
alias cls='clear; ls'
alias clsd='clear; lsd'
alias ll='ls -alFh'
alias la='ls -a'
alias lla='ls -la'
alias l='ls -CF'
alias lsd='ls -d -- */'
alias cj='clear; jobs'
alias clj='clear; jobs; ls'
alias pl='pwd;ls'

# Clear the screen, go to the home dir, say the user and host name, list any running jobs, list dir contents
alias home='clear; cd $HOME; env echo -e "\e[36m$USER"\@$(uname -n)"\e[35m";jobs; env echo -en "\e[39m"; ls'
alias hoe="home; echo 'What did you just call me?!'"

# git aliases that are hard to build into .gitconfig
alias sta='git status'
alias githome='cd "$(git rev-parse --show-toplevel)"'
alias allsta=' find . -type d -name "\.git" \
				-execdir pwd \; \
				-execdir git status -sb \; \
				-execdir echo -e \\n \;' # get the status of every git subdirectory

# Add an "alert" alias for long running commands.  Use like so: `sleep 10; alert`
# This is obsolete when my oh-my-zsh profile is in effect.
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# default to vi-like key bindings for given programs
alias info='info --vi-keys'
alias lynx='lynx --vikeys --use_mouse --enable_scrollback'

#alias viewmd='function _viewmd(){ pandoc -i "$1" -o /tmp/$(basename ${1%.*}.html); chromium-browser /tmp/$(basename ${1%.*}.html); };_viewmd'

# miscellaneous abreviated aliases
infind() {
	find -iname "*$1*"
}
alias vl='/usr/share/vim/vim74/macros/less.sh'
alias gcalc='gcalccmd'
alias trash='gvfs-trash' # TODO: figure out how to use the trash on Arch
alias trashls='gvfs-ls trash://'
alias xop='xdg-open'
alias iR='jupyter console --kernel ir'
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
alias psudo='sudo env PATH="$PATH"' # "path sudo" Use sudo with your current PATH.
alias ssay='spd-say'

# things to control the encrypted journal
alias jrnl-mount="encfs $XDG_DOCUMENTS_DIR/.journal $XDG_DOCUMENTS_DIR/journal"
alias jrnl-umount="fusermount -u $XDG_DOCUMENTS_DIR/journal && df | grep $XDG_DOCUMENTS_DIR/journal | sed 's/^.*$/Seemingly failed to unmount journal./'"
alias jrnl='jrnl-mount; vim $XDG_DOCUMENTS_DIR/journal/`date -I`.md; jrnl-umount'

# reference material
alias chrestomathy="vim $DOTFILES_DIR/chrestomathy.md"
alias colorRef='cat <(colorCodes) <(colorBlocks) | less'

# silly ASCII things
alias gf='echo TFW no gf; fg'
alias zoidberg="cat $DOTFILES_DIR/neat/zoidberg.txt"
alias drop="ogg123 ~/audio/samples/dropIt.ogg 2> /dev/null & cat $DOTFILES_DIR/neat/dropTheBass.txt"
alias gnuLinux="cat $DOTFILES_DIR/neat/gnuLinux.txt"
alias face='awk -v r=$(( $RANDOM % ($(egrep -c '\''^$'\'" $DOTFILES_DIR/neat/faces.txt) +1) )) 'BEGIN{n=0}/^$/{n++;next}{if(n==r)print}' $DOTFILES_DIR/neat/faces.txt" # print a random face
alias lenny="echo '( ͡° ͜ʖ ͡°)'"
alias wut="echo 'ಠ_ಠ'"
alias rainbowClock='watch -t -n1 --color _rainbowHelper'

alias mouseWiggler='watch -n 240 "xdotool mousemove 50 50 mousemove restore"'
alias peppyCaps='~/.xkb/recomp.sh'
# alias bgshuffle='xfdesktop --next'
alias soundCheck='find ~/audio/samples -maxdepth 1 -type f | sort -R | head -n 1 | xargs play'
# Count the empty lines in faces.txt. Pick a random one. Print everything after that, until the next empty line.
alias chungus='play ~/audio/samples/bigChungus.ogg'
# alias tmux='tmux -2' # This should be done in the local config.
