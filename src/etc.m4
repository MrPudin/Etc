divert(-1)dnl

include(`etc_pkg.m4')

ifdef(`ETC_M4',,`
#
# etc.m4
# Etcetera Macros
# Etcetera Deployment System
# 
# Generator Macros
dnl Shorthand macros that generate the rules for generating the makefile rules
dnl for a given methodology specific to the macro, such as remove fetching,
dnl package manager. etc.

dnl Usage: ETC_REMOTE_RESOURCE(<destination>, <src_url>)
dnl Maintain remote resource at 'destination' using resource located at 'url'
dnl
define(ETC_REMOTE_RESOURCE, `dnl
pushdef(`ETC_TARGET',`ETC_BASENAME($2)')dnl

ETC_MAKE_INSTALL_TARGET(ETC_TARGET(),,`dnl
ETC_RETRIEVE($2)dnl
')dnl

ETC_MAKE_UPDATE_TARGET(ETC_TARGET(),,`dnl
ETC_RUN(`rm -rf $1')
ETC_RETRIEVE($2)dnl
')dnl

ETC_MAKE_REMOVE_TARGET(ETC_TARGET(),,`dnl
ETC_RUN(`rm -rf $1')dnl
')dnl

popdef(`ETC_TARGET')dnl
')

dnl Usage: ETC_PKG(<name>, [package manager])
dnl Maintain package by 'name' using the 'package manager'. If package manager
dnl is not specified, would use the system default package mananger
dnl If the package by 'name' is not installed, would install package.
dnl If the package by 'name,' is outdated, would update package.
dnl If the remove target is called, would remove package.
dnl If the specified package manager is not installed, would expand to an empty
dnl string.
define(ETC_PKG,`dnl
ifelse(eval($# < 2),1,`ETC_PKG($1,ETC_SYSTEM_PKG_MANAGER)',`dnl
ifelse(ETC_IS_INSTALLED($2),ETC_TRUE,`dnl
pushdef(`ETC_TARGET',ETC_CHOMP($1))dnl
pushdef(`ETC_PKGMAN',`$2')dnl
ETC_MAKE_PKG_REFRESH(ETC_PKGMAN)

ETC_MAKE_INSTALL_TARGET(ETC_TARGET(),refresh__`'ETC_PKGMAN(),`dnl
ETC_PKG_INSTALL(ETC_PKGMAN,ETC_TARGET)
')dnl

ETC_MAKE_UPDATE_TARGET(ETC_TARGET(),refresh__`'ETC_PKGMAN(),`dnl
ETC_PKG_UPDATE(ETC_PKGMAN,ETC_TARGET)
')dnl

ETC_MAKE_REMOVE_TARGET(ETC_TARGET(),,`dnl
ETC_PKG_REMOVE(ETC_PKGMAN,ETC_TARGET)
')dnl

popdef(`ETC_TARGET')dnl
popdef(`ETC_PKGMAN')dnl
',)')dnl
')

#Git
dnl Usage: ETC_GIT(<url>,<path>)
dnl Maintain git repositiory at 'path' using remote git repositiory pointed to by 'url'
dnl 
define(ETC_GIT,`dnl
pushdef(`ETC_TARGET',`ETC_BASENAME($2)')dnl

ETC_MAKE_INSTALL_TARGET(ETC_TARGET(),,`dnl
ETC_RUN(`git clone "$1" "$2"')
')dnl

ETC_MAKE_UPDATE_TARGET(ETC_TARGET(),,`dnl
ETC_RUN(`git -C "$2" pull')
')dnl

ETC_MAKE_REMOVE_TARGET(ETC_TARGET(),,`dnl
ETC_RUN(`rm -rf $2')dnl
')dnl

popdef(`ETC_TARGET')dnl
')


#Deploy
dnl Usage: ETC_DEPLOY(from, dest)
dnl Mantain file/directory hierarchy with the filepath "DEPLOYMENT_DIRECTORY/from" to
dnl destination. Useful for deploying configuration files
dnl 
define(ETC_DEPLOY,`dnl
pushdef(`ETC_TARGET',`ETC_BASENAME($2)')dnl

ETC_MAKE_INSTALL_TARGET(ETC_TARGET(),,`dnl
ETC_RUN(`cp -af "ETC_DEPLOY_DIR()/$1" "$2"')
')dnl

ETC_MAKE_UPDATE_TARGET(ETC_TARGET(),,`dnl
ETC_RUN(`cp -af "ETC_DEPLOY_DIR()/$1" "$2"')
')dnl

ETC_MAKE_REMOVE_TARGET(ETC_TARGET(),,`dnl
ETC_RUN(`rm -rf "ETC_DEPLOY_DIR()/$1" "$2"')
')dnl

popdef(`ETC_TARGET')dnl
')

#Include Protection
define(`ETC_M4',1)
')dnl INCLUDE PROTECTION DO NOT REMOVE

divert(0)dnl
