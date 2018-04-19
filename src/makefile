#
# makefile
# ETC Bootstrap Makefile
# 

#Variables
DEPLOY_DIR := deploy
SOURCE_DIR := source
MARK_DIR := mark
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

$(SOURCE_DIR)/%.mk: $(DEPLOY_DIR)/%.etc
	m4 --include=. $< >$@

$(PP_SOURCES): $(SOURCE_DIR) $(MARK_DIR)

$(SOURCE_DIR):
	mkdir -p $(SOURCE_DIR)
$(MARK_DIR):
	mkdir -p $(MARK_DIR)
	
include $(PP_SOURCES)
