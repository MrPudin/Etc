#
# makefile.
# Etc Project Makefile
# *NOTE: this is NOT a deployment makefile
#

.PHONY: all install clean docs
.DEFAULT: all

WORK_DIR := .etc_work/

all: install docs

#TODO: 2.1 move this to  etc.m4
work:
	mkdir -p $(WORK_DIR)
	cp -avf deploy $(WORK_DIR)

$(WORK_DIR)/etc.m4: $(WORK_DIR)
	cp -avf src/etc.m4 $(WORK_DIR)
$(WORK_DIR)/makefile: $(WORK_DIR)
	cp -avf src/makefile $(WORK_DIR)
$(WORK_DIR):
	mkdir -p $(WORK_DIR)

# END

install: 
	cp -avf src/etcetera.sh /usr/local/bin/etcetera
	chmod a+rx /usr/local/bin/etcetera

remove: 
	rm -rf /usr/local/bin/etcetera

clean:
	rm -rf $(WORK_DIR)
	rm -f docs/macro.txt

docs: docs/macro.txt

docs/macro.txt: src/etc.m4
	sed -e '/^dnl /!d; s/dnl //g' $? >$@

