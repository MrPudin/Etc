#
# makefile.
# Etc Project Makefile
# *NOTE: this is NOT a deployment makefile
#

.PHONY: all install clean docs

all: install docs

install: src
	cp -avf src ~/.etc/
remove:
	rm -rf

clean:
	rm docs/macro.txt

docs: docs/macro.txt

docs/macro.txt: src/etc.m4
	sed -e '/^dnl /!d; s/dnl //g' $? >$@
