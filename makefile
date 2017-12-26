#
# makefile.
# Etc Project Makefile
# *NOTE: this is NOT a deployment makefile
#

.PHONY: all install clean docs
.DEFAULT: all

all: install docs

install: src/etc.m4 src/makefile src/etcetera.sh deploy
	mkdir -p ~/.etc
	cp -avf src/etc.m4 ~/.etc/
	cp -avf src/makefile ~/.etc/
	cp -avf deploy ~/.etc/
	cp -avf src/etcetera.sh /usr/local/bin/etcetera
	chmod a+rx /usr/local/bin/etcetera

remove:
	rm -rf ~/.etc
	rm -rf /usr/local/bin/etcetera

clean:
	rm docs/macro.txt

docs: docs/macro.txt

docs/macro.txt: src/etc.m4
	sed -e '/^dnl /!d; s/dnl //g' $? >$@
