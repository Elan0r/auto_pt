#!/bin/bash

figlet Runtime

tmux split-window -h
tmux send 'tail --lines 999 --follow /root/output/runtime.txt' ENTER
tmux last-pane
