#
# makefile.
# Etc Project Makefile
# Used for installing and removing the  etcetera command line tool
#k

.PHONY: all install clean 
.DEFAULT: all

WORK_DIR := .etc_work/

all: install 

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
