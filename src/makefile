#
# makefile
# ETC Bootstrap Makefile
# 

#Variables
WORK_DIR := .etc
SOURCE_DIR := $(WORK_DIR)/src
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
	rm -rf $(SOURCE_DIR)

$(SOURCE_DIR)/%.mk: %.etc
	m4 --include=. $< >$@

$(PP_SOURCES): $(SOURCE_DIR)
$(SOURCE_DIR):
	mkdir -p $@

include $(PP_SOURCES)
