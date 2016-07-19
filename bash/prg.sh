#
# ~/etc/bash/prg.sh
# Usr Config - Login Program 
# 
# Made by Zhu Zhan Yan.
# Copyright (c) 2015. All Rughts Reserved.
#

NO_X=true
NO_TMUX=false

if [ ! ${NO_X} == true ] && [ -z ${TMUX} ] && [ ! xset q &>/dev/null ]
then
    startx
fi

if [ ! ${NO_TMUX} == true ] && [ -z ${TMUX} ]
then
    tmux
fi
