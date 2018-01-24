#
# makefile.
# Etc Project Makefile
# *NOTE: this is NOT a deployment makefile
#

.PHONY: all install clean docs
.DEFAULT: all

all: install docs

install: src/etc.m4 src/makefile src/etcetera.sh deploy
	mkdir -p $(HOME)/.etc
	rm -f $(HOME)/.etc/.etc_work/source/*
	cp -avf src/etc.m4 $(HOME)/.etc/
	cp -avf src/makefile $(HOME)/.etc/
	cp -avf deploy $(HOME)/.etc/
	cp -avf src/etcetera.sh /usr/local/bin/etcetera
	chmod a+rx /usr/local/bin/etcetera

remove:
	rm -rf $(HOME)/.etc
	rm -rf /usr/local/bin/etcetera

clean:
	rm docs/macro.txt

docs: docs/macro.txt

docs/macro.txt: src/etc.m4
	sed -e '/^dnl /!d; s/dnl //g' $? >$@
