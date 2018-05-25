divert(-1)dnl

include(`etc_util.m4')

ifdef(`ETC_MAKE_M4',,`dnl Include Protection
dnl 
dnl src/etc_make.m4
dnl Make Macros
dnl Etcetera deployment system 
dnl 

dnl The macros in this file generate makefile rules to build a makefile with
dnl 3 targets: install/update/remove, to install, update and remove the deployment
dnl respectively.
dnl Build process:
dnl deployment <- modules <- targets

# Module Macros
dnl Each module will generate makefile rules to build the module:
dnl install__<module>, update__<module> and remove__<module>to install, update 
dnl and remove the module respectively. They are made the dependency of 
dnl the deployment targets install/update/remove so that the module is
dnl installed, updated or removed when the deployment is installed, updated or 
dnl removed
dnl full_install/update/remove run the install/update/remove target for the module
dnl and the any hooks that are attached.

dnl Usage: ETC_MAKE_ATTACH_MODULE(<module>)
dnl Attach the given 'module' to the to run on the 'install'/'update'/'remove' 
dnl makefile targets.
dnl Internally makes install depend on install__<module>
dnl update depend on update__<module>
dnl remove depend on remove__<module>
dnl And setups the execution of hooks
define(ETC_MAKE_ATTACH_MODULE,`
ETC_MAKE_SETUP()

.PHONY: full_install__$1 full_update__$1 full_remove__$1
.PHONY: install__$1 update__$1 remove__$1 
.PHONY: hook_setup__$1 hook_upgrade__$1 hook_teardown__$1

install:: full_install__$1
update:: full_update__$1
remove:: full_remove__$1

full_install__$1: hook_setup__$1
dnl Runs in desired sequence install__module -> hook_setup 
hook_setup__$1:: install__$1

full_update__$1:: hook_upgrade__$1
dnl Runs in desired sequence update_module -> hook_upgrade 
hook_upgrade__$1:: update__$1

full_remove__$1:: remove__$1
dnl Runs in desired sequence hook_teardown -> remove__module
remove__$1:: hook_teardown__$1
')

# Setup Macros
dnl Usage: ETC_MAKE_SETUP
dnl Expands to the makefile rules that will setup the core targets
dnl (install/update/remove). Also expands to the makefile rules that 
dnl will setup the working directory. Only expands once, so subsequent
dnl expansions will expand into an empty string
define(ETC_MAKE_SETUP,`dnl
ifdef(`ETC_MAKE_SETUP_COMPLETE',`',`dnl
.PHONY: install update remove

install:: setup_work_dirs
update:: setup_work_dirs
remove:: setup_work_dirs

setup_work_dirs:
	@mkdir -p ETC_WORK_DIR()
	@mkdir -p ETC_WORK_DIR()`/mark'

define(`ETC_MAKE_SETUP_COMPLETE',1)
')')


# Module Macros cont.
dnl Usage: ETC_MODULE_BEGIN(<name>)
dnl        <implementation>
dnl        ETC_MODULE_END(<name>)
dnl Define a multiline module.
dnl Global macro 'ETC_CURRENT_MODULE tracks the current module
define(ETC_MODULE_BEGIN,`dnl
pushdef(`ETC_CURRENT_MODULE',$1)dnl
ETC_MAKE_ATTACH_MODULE($1)dnl
')

define(ETC_MODULE_END,`popdef(`ETC_CURRENT_MODULE')')

dnl Usage: ETC_MODULE(<name>,<implementation>)
dnl Define a one line module
dnl 
define(ETC_MODULE,`dnl
ETC_MODULE_BEGIN($1)
$2
ETC_MODULE_END($1)
')

dnl Usage: ETC_MODULE_DEPEND(<depender>,<dependent>)
dnl Generates the makefile rules to make the module 'depender' dependent on 
dnl the module 'dependent'
dnl Ensures that the dependent will be installed/updated before the depender
dnl and that the depender will be removed before the depender is removed
define(ETC_MODULE_DEPEND,`dnl
install__$1:: install__$2

update__$1:: update__$2

remove__$2:: remove__$1
')

# Hooks
dnl Note: Hooks are tied to the modules, not the targets

dnl Usage: ETC_SETUP_HOOK(<module>,<implementation>)
dnl Setup Hooks run after the entire module of has finished installing,
dnl when which the provided implementation is executed.
dnl If 'module' is not specifed, will assume that hooks belong to the current module
dnl Note that the user who runs the hook is not set, use the ETC_RUN_NORM method to
dnl run as normal unprevileged  user
define(ETC_SETUP_HOOK,`ifelse(eval($# < 2),1,`ETC_SETUP_HOOK(ETC_CURRENT_MODULE(),`$1')',`dnl
hook_setup__$1:: 
	ETC_MAKE_INDENT(`$2')
')')


dnl Usage: ETC_UPGRADE_HOOK(<module>,<implementation>)
dnl Setup Hooks run after the entire module of has finished upgrading,
dnl when which the provided implementation is executed.
dnl If 'module' is not specifed, will assume that hooks belong to the current module
dnl Note that the user who runs the hook is not set, use the ETC_RUN_NORM method to
dnl run as normal unprevileged  user
define(ETC_UPGRADE_HOOK,`ifelse(eval($# < 2),1,`ETC_UPGRADE_HOOK(ETC_CURRENT_MODULE(),`$1')',`dnl
hook_upgrade__$1:: 
	ETC_MAKE_INDENT(`$2')
')')


dnl Usage: ETC_TEARDOWN_HOOK(<module>,<implementation>)
dnl Teardown hooks run before the module is removed,
dnl when which the provided implementation is executed.
dnl If 'module' is not specifed, will assume that hooks belong to the current module
dnl Note that the user who runs the hook is not set, use the ETC_RUN_NORM method to
dnl run as normal unprevileged  user
define(ETC_TEARDOWN_HOOK,`ifelse(eval($# < 2),1,`ETC_TEARDOWN_HOOK(ETC_CURRENT_MODULE(),`$1')',`dnl
hook_teardown__$1::
	ETC_MAKE_INDENT(`$2')
')')


# Target Macros
dnl Each target will also generate makefile rules to target:
dnl install__<module>__<target>, update__<module>__<target> and 
dnl remove__<module>__<target>to install, update and remove te target 
dnl respectively. They are made the dependency of the deployment targets 
dnl install/update/remove so that the target is installed, updated or 
dnl removed when the module is installed, updated or removed

dnl Usage: ETC_MAKE_INSTALL_TARGET(<target>, <dep_target>, <implementation>)
dnl Generates the makefile rules to update 'target' for the current module 
dnl using 'implementation'
dnl Makes install__<module> depend on install__<target>
define(ETC_MAKE_INSTALL_TARGET,`
.PHONY: install__`'ETC_CURRENT_MODULE()`'__$1

install__`'ETC_CURRENT_MODULE():: install__`'ETC_CURRENT_MODULE()`'__$1

install__`'ETC_CURRENT_MODULE()`'__$1: `$2'
	ETC_MAKE_INDENT(`$3')dnl Indent \t to statify makefile syntax requirement
')

dnl Usage: ETC_MAKE_UPDATE_TARGET(<target>, <dep_target>, <implementation>)
dnl Generates the makefile rules to update 'target' for the current module 
dnl using 'implementation'
dnl Makes update__<module> depend on update__<target>
define(ETC_MAKE_UPDATE_TARGET,`
.PHONY: update__`'ETC_CURRENT_MODULE()`'__$1

update__`'ETC_CURRENT_MODULE():: update__`'ETC_CURRENT_MODULE()`'__$1

update__`'ETC_CURRENT_MODULE()`'__$1: `$2'
	ETC_MAKE_INDENT(`$3')dnl Indent \t to statify makefile syntax requirement
')

dnl Usage: ETC_MAKE_REMOVE_TARGET(<target>, <dep_target>, <implementation>)
dnl Generates the makefile rules to remove 'target' for the current module
dnl using 'implementation'
dnl Makes remove__<module> depend on remove__<target>
define(ETC_MAKE_REMOVE_TARGET,`dnl
.PHONY: remove__`'ETC_CURRENT_MODULE()`'__$1

remove__`'ETC_CURRENT_MODULE():: remove__`'ETC_CURRENT_MODULE()`'__$1

remove__`'ETC_CURRENT_MODULE()`'__$1: `$2'
	ETC_MAKE_INDENT(`$3')dnl Indent \t to statify makefile syntax requirement
')
define(`ETC_MAKE_M4',1)
')dnl Include Proctection
divert(0)dnl
