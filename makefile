#
# makefile.
# Etc Project Makefile
# Used for installing and removing the  etcetera command line tool
#k

.PHONY: install clean 
.DEFAULT: install

install: 
	cp -avf src/etcetera.sh /usr/local/bin/etcetera
	chmod a+rx /usr/local/bin/etcetera

remove: 
	rm -rf /usr/local/bin/etcetera
