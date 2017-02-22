#!/bin/sh
tmux new-session -d 'top -o %MEM'
tmux new-window 'vim orbit.R'
tmux split-window -v 'R'
tmux split-window -h
tmux attach -d
echo asdf
