#
# makefile.
# Etc Project Makefile
# *NOTE: this is NOT a deployment makefile
#

.PHONY: all install clean docs
.DEFAULT: all

WORK_DIR := .etc_work/

all: install docs

install: src/etc.m4 src/makefile src/etcetera.sh deploy
	mkdir -p $(WORK_DIR)
	cp -avf src/etc.m4 $(WORK_DIR)
	cp -avf src/makefile $(WORK_DIR)
	cp -avf deploy $(WORK_DIR)
	cp -avf src/etcetera.sh /usr/local/bin/etcetera
	chmod a+rx /usr/local/bin/etcetera

remove: 
	rm -rf /usr/local/bin/etcetera

clean:
	rm -rf $(WORK_DIR)
	rm docs/macro.txt

docs: docs/macro.txt

docs/macro.txt: src/etc.m4
	sed -e '/^dnl /!d; s/dnl //g' $? >$@

