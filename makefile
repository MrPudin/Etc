#
# ~/etc/makefile
# Usr Config - Generate Links and Copies
# Version 0.0.2 
#
# Made by Zhu Zhan Yan.
# Copyright (c) 2016. All Rights Reserved.
#

#Var
#Var>Info
INFO_NAME=ETC Cfg Linker
INFO_VERSION=0.0.2
#Var>Prg
RM=rm -f
LN=ln -f
LN_S= ln -sf
CP=cp -af
MV=mv -f
SHELL=bash
#Var>Files
SRC=
PDCT=
#Bash
SRC+=bash/bashrc
PDCT+=~/.bashrc
SRC+=bash/bash_profile
PDCT+=~/.bash_profile 
#Vim
SRC+=vim/vimrc
PDCT+=~/.vimrc
#Tmux
SRC+=tmux/tmux.conf
PDCT+=~/.tmux.conf
#i3
SRC+=i3/wm_config
PDCT+=~/.i3/config
SRC+=i3/status_config
PDCT+=~/.i3status.conf
#Xsvr
SRC+=xsvr/xresources
PDCT+=~/.Xresources

#Def>Newline
define \n


endef

#Tgrt
PHONY: install uninstall

install:
	@printf "%s\nVersion %s\n" "$(INFO_NAME)" "$(INFO_VERSION)"
	@printf "Installing...\n"
	$(foreach i,$(shell echo {1..$(words $(SRC))}),\
		$(LN) $(word $(i),$(SRC)) $(word $(i),$(PDCT))$(\n)\
	)
	@printf "Installation Finished\n"

uninstall:
	@printf "%s\nVersion %s\n" "$(INFO_NAME)" "$(INFO_VERSION)"
	@printf "Uninstalling...\n"
	$(foreach i,$(shell echo {1..$(words $(PDCT))}),\
		$(RM) $(word $(i),$(PDCT))$(\n)\
	)
	@printf "Uninstallation Complete\n"
