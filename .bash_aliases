#!/bin/bash
# enable color support of ls and friends. Also add handy aliases.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some navigation ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear; ls'
alias clsd='clear; lsd'
alias lsd='ls -d -- */'
alias cj='clear; jobs'
alias clj='clear; jobs; ls'
alias pl='pwd;ls'
alias home='clear; cd $HOME; jobs; ls'
alias hoe="home; echo 'What did you just call me?!'"

# git aliases that are hard to build into .gitconfig
alias sta='git status'
alias githome='cd "$(git rev-parse --show-toplevel)"'

# Add an "alert" alias for long running commands.  Use like so: `sleep 10; alert`
# This is obsolete when my oh-my-zsh profile is in effect.
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# default to vi-like key bindings for given programs
alias info='info --vi-keys'
alias lynx='lynx --vikeys --use-mouse'

#alias viewmd='function _viewmd(){ pandoc -i "$1" -o /tmp/$(basename ${1%.*}.html); chromium-browser /tmp/$(basename ${1%.*}.html); };_viewmd'

# miscellaneous abreviated aliases
alias gcalc='gcalccmd'
alias trash='gvfs-trash'
alias trashls='gvfs-ls trash://'
alias xop='xdg-open'
# function linfo { info $@ | less; }
# alias todo='w2do'
alias iR='jupyter console --kernel ir'
# alias hist='history'
alias histless='history | less'
# alias xonotic='sh ~/Xonotic/xonotic-linux-glx.sh'
alias pyserve2='python2 -m SimpleHTTPServer'
alias pyserve3='python3 -m http.server'
alias psudo='sudo env PATH="$PATH"'
alias mouseWiggler='watch -n 240 "xdotool mousemove 50 50 mousemove restore"'
alias ssay='spd-say'
alias peppyCaps='~/.xkb/recomp.sh'
alias rainbowClock='watch -t -n1 --color _rainbowHelper'
# alias bgshuffle='xfdesktop --next'
alias soundCheck='find ~/audio/samples -maxdepth 1 -type f | sort -R | head -n 1 | xargs play'
alias gf='echo TFW no gf; fg'
alias chrestomathy='vim ~/dotfiles/chrestomathy.md'
alias vl='/usr/share/vim/vim74/macros/less.sh'
alias drop='ogg123 ~/audio/samples/dropIt.ogg 2> /dev/null & cat ~/dotfiles/neat/dropTheBass.txt'
alias allsta=' find . -type d -name "\.git" \
				-execdir pwd \; \
				-execdir git status -sb \; \
				-execdir echo -e \\n \;'
# Count the empty lines in faces.txt. Pick a random one. Print everything after that, until the next empty line.
alias face='awk -v r=$(( $RANDOM % ($(egrep -c '\''^$'\'' ~/dotfiles/neat/faces.txt) +1) )) '\''BEGIN{n=0}/^$/{n++;next}{if(n==r)print}'\'' ~/dotfiles/neat/faces.txt'
infind() {
	find -iname "*$1*"
}
alias jsync='nice -n 10 rsync -a --partial --inplace --info=progress2'
alias pingg='ping google.com'
alias audio-dl='youtube-dl -f '\''bestaudio'\'
alias batteryPercent='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -P '\''(?<=\s)[0-9]*%'\'
alias cath='highlight --out-format ansi'
alias jrnl-mount='encfs /home/joedang/Documents/.journal /home/joedang/Documents/journal'
alias jrnl-umount='fusermount -u /home/joedang/Documents/journal && df | grep /home/joedang/Documents/journal | sed '\''s/^.*$/Seemingly failed to unmount journal./'\'
alias jrnl='jrnl-mount; vim /home/joedang/Documents/journal/`date -I`.md; jrnl-umount'
alias lenny="echo '( ͡° ͜ʖ ͡°)'"
alias wut="echo 'ಠ_ಠ'"
alias chungus='play ~/audio/samples/bigChungus.ogg'
alias qmv='qmv -o spaces'
