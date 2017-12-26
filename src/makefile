#
# makefile
# ETC Bootstrap Makefile
# 

#Variables
WORK_DIR := .etc_work
SOURCE_DIR := $(WORK_DIR)/source
MARK_DIR :f= $(WORK_DIR)/mark
MACRO := etc.m4
SOURCES := $(shell find . -name "?*.etc")
PP_SOURCES := $(addprefix $(SOURCE_DIR)/,\
	$(patsubst %.etc,%.mk,$(notdir $(SOURCES))))

#Targets
.PHONY: all install update remove clean
.DEFAULT: all

all: update

install:: $(PP_SOURCES)

update:: $(PP_SOURCES)
	
remove:: $(PP_SOURCES)

clean:
	rm -rf $(WORK_DIR)

$(SOURCE_DIR)/%.mk: %.etc
	m4 --include=. $< >$@

$(PP_SOURCES): $(SOURCE_DIR)
$(SOURCE_DIR):
	mkdir -p $@

include $(PP_SOURCES)
