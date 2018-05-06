divert(-1)dnl
ifdef(`ETC_MAKE_M4',, dnl Include Protection
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
include(`etc_util.m4')

# Module Macros
dnl Each module will generate makefile rules to build the module:
dnl install__<module>, update__<module> and remove__<module>to install, update 
dnl and remove the module respectively. They are made the dependency of 
dnl the deployment targets install/update/remove so that the module is
dnl installed, updated or removed when the deployment is installed, updated or 
dnl removed

dnl Usage: ETC_MAKE_ATTACH_MODULE(<module>)
dnl Attach the given 'module' to the to run on the 'install'/'update'/'remove' 
dnl makefile targets.
dnl Internally makes install depend on install__<module>
dnl update depend on update__<module>
dnl remove depend on remove__<module>
define(ETC_MAKE_ATTACH_MODULE,`
.PHONY: install__$1 update__$1 remove__$1 
install:: install__$1
update:: update__$1
remove:: remove__$1
')


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

# Target Macros
dnl Each target will also generate makefile rules to target:
dnl install__<target>, update__<target> and remove__<target>to install, update 
dnl and remove te target respectively. They are made the dependency of 
dnl the deployment targets install/update/remove so that the target is
dnl installed, updated or removed when the module is installed, updated or 
dnl removed

dnl Usage: ETC_MAKE_INSTALL_TARGET(<target>, <implementation>)
dnl Generates the makefile rules to update 'target' for the current module 
dnl using 'implementation'
dnl Makes install__<module> depend on install__<target>
define(ETC_MAKE_INSTALL_TARGET,`
install__`'ETC_CURRENT_MODULE():: install__$1

install__$1:
	ETC_MAKE_INDENT($2)
	ETC_MARK($1) dnl Indent \t to statify makefile syntax requirement
')

dnl Usage: ETC_MAKE_UPDATE_TARGET(<target>, <implementation>)
dnl Generates the makefile rules to update 'target' for the current module 
dnl using 'implementation'
dnl Makes update__<module> depend on update__<target>
define(ETC_MAKE_UPDATE_TARGET,`
update___`'ETC_CURRENT_MODULE():: update__$1

update__$1:
	ETC_MAKE_INDENT($2)
	ETC_MARK($1) dnl Indent \t to statify makefile syntax requirement
')

dnl Usage: ETC_MAKE_REMOVE_TARGET(<target>, <implementation>)
dnl Generates the makefile rules to remove 'target' for the current module
dnl using 'implementation'
dnl Makes remove__<module> depend on remove__<target>
define(ETC_MAKE_REMOVE_TARGET,`
remove__`'ETC_CURRENT_MODULE():: remove__$1

remove__$1:
	ETC_MAKE_INDENT($2)
	ETC_UNMARK($1) dnl Indent \t to statify makefile syntax requirement
')

define(`ETC_MAKE_M4',ETC_TRUE)
)dnl Include Proctection
divert(0)dnl
