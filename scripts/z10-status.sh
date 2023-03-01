#!/bin/bash

figlet Runtime

tmux split-window -h
tmux send 'tail --follow /root/output/runtime.txt' ENTER
tmux last-pane
