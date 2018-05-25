divert(-1)dnl
include(`etc_make.m4')
ifdef(`ETC_PKG_M4',,`
dnl 
dnl src/etc_pkg.m4
dnl Package Macros
dnl Etcetera Deployment System
dnl
dnl Package system works by extract package manager infomation deploy/etc_pkg.etc
dnl a semicolon(;) seperated value file defining how to use a specific package manager
dnl to install, update and remove package
dnl

dnl Usage: ETC_PKG_CONFIG(<pkg_manager>)
dnl Expands to the line of the package manager infomation config
dnl that describes the given package manager specified by 'pkg_manager' as name.
dnl 
define(ETC_PKG_CONFIG,`dnl
ifelse(ETC_EXISTS(ETC_PKG_CONFIG_PATH),ETC_TRUE,dnl Check if package infomation file exists
ETC_GREP(`$1',ETC_FILTER_COMMENT(ETC_PKG_CONFIG_CONTENT)),
`')dnl Empty return if file not found 
')

dnl Usage: ETC_PKG_CONFIG_CONTENT
dnl Expands to the contents of the package configuration infomation file
dnl Used as on optimaisation, only reads the file once.
define(ETC_PKG_CONFIG_CONTENT,`dnl
ifelse(ETC_EXISTS(ETC_PKG_CONFIG_PATH),ETC_TRUE,` dnl Check if package infomation file exists
ifdef(`__ETC_PKG_CONFIG_CONTENT__',,`dnl
define(`__ETC_PKG_CONFIG_CONTENT__',ETC_READ(ETC_PKG_CONFIG_PATH))')
__ETC_PKG_CONFIG_CONTENT__ dnl
',`')
')


dnl Usage: ETC_PKG_CONFIG_PATH
dnl Expands to the filepath of the package manager infomation config
define(ETC_PKG_CONFIG_PATH,`ETC_DEPLOY_DIR()/etc_pkg.csv')

dnl Usage: ETC_PKG_CHECK_FLAG(<pkg_manager>,<flag>)
dnl Checks whether the given flag is for the package manager given by name 
dnl 'pkg_manager' in the package manager infomation configuration file
dnl The flags allows are defined as the 6th field in the package configuration
dnl and are specified as follows:
dnl m - macos dependency
dnl l - linux dependency      
dnl s - system package manager
dnl r - requires superuser permissions
dnl e - continue deployment on non zero return code
dnl Expands to ETC_TRUE if the flag is set, otherwise ETC_FALSE
define(ETC_PKG_CHECK_FLAG,`dnl
ifelse(patsubst(ETC_CHOMP(ETC_SLICE(`;',6,ETC_PKG_CONFIG(`$1'))),`.*$2.*',ETC_TRUE),ETC_TRUE,dnl
ETC_TRUE,ETC_FALSE)')

dnl ETC_PKG_EXPAND_FLAGS(<pkg_manager>,<pkg_cmd>)
dnl Expands to the given 'given' pkg_cmd, with the flags given in package manager
dnl infomation file.
define(ETC_PKG_EXPAND_FLAGS,`dnl
ifelse(ETC_PKG_CHECK_FLAG(`$1',`e'),ETC_TRUE,`-',`')dnl
ifelse(ETC_PKG_CHECK_FLAG(`$1',`r'),ETC_TRUE,dnl
`ETC_RUN_SUDO(`$2')',dnl
`ETC_RUN_NORM(`$2')')')

dnl Usage: ETC_PKG_INSTALL(<pkg_manager>,<pkg>)
dnl Expands the install command for the given package manager name 'pkg_manager'
dnl to install the package with the given name 'pkg'
dnl The install command is defined to be the second field.
define(ETC_PKG_INSTALL,`dnl
ETC_PKG_EXPAND_FLAGS(`$1',`$1' ETC_CHOMP(ETC_SLICE(`;',2,ETC_PKG_CONFIG(`$1'))) `$2') dnl
')

dnl Usage: ETC_PKG_UPDATE(<pkg_manager>,<pkg>)
dnl Expands the update command for the given package manager name 'pkg_manager'
dnl to update the package with the given name 'pkg'
dnl The update command is defined to be the third field
define(ETC_PKG_UPDATE,`dnl
ETC_PKG_EXPAND_FLAGS(`$1',`$1' ETC_CHOMP(ETC_SLICE(`;',3,ETC_PKG_CONFIG(`$1'))) `$2') dnl
')

dnl Usage: ETC_PKG_REMOVE(<pkg_manager>,<pkg>)
dnl Expands the remove command for the given package manager name 'pkg_manager'
dnl to remove the package with the given name 'pkg'
dnl The remove command is defined to be the fourth field.
define(ETC_PKG_REMOVE,`dnl
ETC_PKG_EXPAND_FLAGS(`$1',`$1' ETC_CHOMP(ETC_SLICE(`;',4,ETC_PKG_CONFIG(`$1'))) `$2') dnl
')

dnl Usage: ETC_PKG_REFRESH(<pkg_manager>)
dnl Expands the refresh command for the given package manager name 'pkg_manager'
dnl to refresh the package manager's internal listings.
dnl If the package does not have a refresh command, will expand to empty string ''
dnl The refresh command is defined to be the fifth field.
define(ETC_PKG_REFRESH,`dnl
pushdef(`REFRESH_CMD',ETC_CHOMP(ETC_SLICE(`;',5,ETC_PKG_CONFIG(`$1'))))
ifelse(REFRESH_CMD,,`',ETC_PKG_EXPAND_FLAGS(`$1',`$1' REFRESH_CMD)) dnl
popdef(`REFRESH_CMD')dnl
')

dnl Usage: ETC_SYSTEM_PKG_MANAGER
dnl Expands to the default system package manager.
dnl By default, etcetera will automatically select a system package manager to
dnl when which package manager to use is not specified.
define(ETC_SYSTEM_PKG_MANAGER,`dnl
pushdef(`PKG_CONFIG_CONTENT',ETC_FILTER_EMPTY_LINE(ETC_FILTER_COMMENT(ETC_PKG_CONFIG_PATH)))dnl
ETC_CHOMP(ifelse(eval($# < 1),1,`ETC_SYSTEM_PKG_MANAGER(ETC_LINE_COUNT(PKG_CONFIG_CONTENT))',`dnl
ifelse(eval($1 < 1),1,`',`dnl Empty string: no available system package manager
pushdef(`CANIDATE_SYS_PKG_MAN',ETC_CHOMP(ETC_SLICE(`;',1,ETC_LINE($1,PKG_CONFIG_CONTENT))))dnl
ifelse(ETC_PKG_CHECK_FLAG(CANIDATE_SYS_PKG_MAN,`s'),ETC_FALSE,`ETC_SYSTEM_PKG_MANAGER(eval($1 - 1))',`dnl
ifelse(ETC_PKG_CHECK_FLAG(CANIDATE_SYS_PKG_MAN,`m'),ETC_TRUE,`dnl
ifelse(ETC_OS,`Darwin',CANIDATE_SYS_PKG_MAN,`ETC_SYSTEM_PKG_MANAGER(eval($1 - 1))')',`dnl
ifelse(ETC_PKG_CHECK_FLAG(CANIDATE_SYS_PKG_MAN,`l'),ETC_TRUE,`dnl
ifelse(ETC_OS,`Linux',CANIDATE_SYS_PKG_MAN,`ETC_SYSTEM_PKG_MANAGER(eval($1 - 1))')', dnl
CANIDATE_SYS_PKG_MAN)')') dnl
popdef(`CANIDATE_SYS_PKG_MAN')dnl
popdef(`PKG_CONFIG_CONTENT')dnl
')'))')

dnl Usage: ETC_MAKE_PKG_REFRESH(<pkg_manager>)
dnl Expands to the makefile rules refresh the package manager, for the first
dnl expansion. Subsequent expansion expand to an empty string.
define(ETC_MAKE_PKG_REFRESH,`dnl
ifdef(`ETC_MAKE_PKG_REFRESH_FLAG__$1',`',`dnl
.PHONY: refresh__$1
refresh__$1:
	ETC_MAKE_INDENT(ETC_PKG_REFRESH($1))
define(`ETC_MAKE_PKG_REFRESH_FLAG__$1',1)dnl
')')


define(`ETC_PKG_M4',1)
')dnl INCLUDE PROTECTION DO NOT REMOVE
divert(0)dnl
