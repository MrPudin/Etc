#
# makefile
# ETC Bootstrap Makefile
# 

#Variables
WORK_DIR := .etc_work
DEPLOY_DIR := deploy
SOURCE_DIR := $(WORK_DIR)/source
MARK_DIR := $(WORK_DIR)/mark
MACRO := etc.m4
SOURCES := $(shell find . -name "?*.etc")
PP_SOURCES := $(addprefix $(SOURCE_DIR)/,\
	$(patsubst %.etc,%.mk,$(notdir $(SOURCES))))
UPDATE_DELAY := 5
UPDATE_COUNT := 10

#Targets
.PHONY: all install update remove clean
.DEFAULT: all

all: update

install:: $(PP_SOURCES)

update:: $(PP_SOURCES)
	
remove:: $(PP_SOURCES)

clean:
	rm -rf $(WORK_DIR)

$(SOURCE_DIR)/%.mk: $(DEPLOY_DIR)/%.etc
	m4 --include=. $< >$@

$(PP_SOURCES): $(WORK_DIR)

$(WORK_DIR):
	mkdir -p $@
	mkdir -p $(SOURCE_DIR)
	mkdir -p $(WORK_DIR)
	mkdir -p $(MARK_DIR)
	
include $(PP_SOURCES)
