divert(-1)dnl
ifdef(`ETC_M4',,
#
# etc.m4
# Etcetera Macros
# Etcetera Deployment System
# 

include(`etc_util.m4')
include(`etc_make.m4')
include(`etc_pkg.m4')

# Generator Macros
dnl Shorthand macros that generate the rules for generating the makefile rules
dnl for a given methodology specific to the macro, such as remove fetching,
dnl package manager. etc.

dnl Usage: ETC_REMOTE_RESOURCE(<destination>, <src_url>)
dnl Maintain remote resource at 'destination' using resource located at 'url'
dnl
define(ETC_REMOTE_RESOURCE, `dnl
pushdef(`ETC_TARGET',`ETC_BASENAME($1)')dnl
ETC_MAKE_INSTALL_TARGET(ETC_TARGET(),`dnl
ETC_RETRIEVE($2)dnl
')dnl

ETC_MAKE_UPDATE_TARGET(ETC_TARGET(),`dnl
ETC_RUN_NORM(`rm -rf $1')
ETC_RETRIEVE($2)dnl
')dnl

ETC_MAKE_REMOVE_TARGET(ETC_TARGET(),`dnl
ETC_RUN_NORM(`rm -rf $1')dnl
')dnl
')

#Package Manager 
dnl Usage: ETC_PKG_SELECT([brew|apt-get|apt-fast|pip])
dnl Select the package manager referenced by 'name' for use.
dnl If argument is obmitted, reset package manager selection to default.
dnl If selected package manager isnt supported, would expand to an empty string
dnl
define(ETC_PKG_SELECT,`dnl
ifelse(eval($#>0),ETC_TRUE,ifelse(ETC_INSTALLED($1),ETC_TRUE,dnl
`pushdef(`ETC_PKG_MANAGER', $1)'ETC_TRUE,ETC_FALSE),`dnl
ifelse(ETC_INSTALLED(brew),ETC_TRUE,`define(`ETC_PKG_MANAGER', brew)'ETC_TRUE,dnl
ifelse(ETC_INSTALLED(apt-get),ETC_TRUE, `define(`ETC_PKG_MANAGER', apt-get)'ETC_TRUE,dnl
ifelse(ETC_INSTALLED(apt-fast),ETC_TRUE, `define(`ETC_PKG_MANAGER', apt-fast)'ETC_TRUE,dnl
ETC_FALSE)))')')

dnl Usage: ETC_PKG_REFRESH
dnl Expands to the command used to refresh the current package manager's index
dnl If selected package manager isnt supported, would expand to an empty string
dnl 
define(ETC_PKG_REFRESH,`dnl
ETC_MODULE_BEGIN(`__ETC_PKG_REFRESH__')
install update:: 
	dnl
ifelse(ETC_PKG_MANAGER,brew,brew update,dnl
ifelse(ETC_PKG_MANAGER,apt-get,ETC_RUN_USER(`root',`apt-get update'),dnl
ifelse(ETC_PKG_MANAGER,apt-fast,ETC_RUN_USER(`root',`apt-fast update'),)))
ETC_MODULE_END(`__ETC_PKG_REFRESH__')')

dnl Usage: ETC_PKG_INSTALL(name)
dnl Expands to the command used to install the package 'name' using the current
dnl selected package manager. 
dnl If selected package manager isnt supported, would expand to an empty string
dnl
define(ETC_PKG_INSTALL,`dnl
ifelse(ETC_PKG_MANAGER,brew,brew install $1,dnl
ifelse(ETC_PKG_MANAGER,apt-get,ETC_RUN_USER(`root',`apt-get -y install $1'),dnl
ifelse(ETC_PKG_MANAGER,apt-fast,ETC_RUN_USER(`root',`apt-fast -y install $1'),dnl
ifelse(ETC_PKG_MANAGER,pip,pip install $1,dnl
ifelse(ETC_PKG_MANAGER,pip3,pip3 install $1,dnl
ifelse(ETC_PKG_MANAGER,gem,gem install $1,dnl
ifelse(ETC_PKG_MANAGER,cpan,cpanm -S --installdeps $1,)))))))')

dnl Usage: ETC_PKG_UPDATE(<name>)
dnl Expands to the command used to update the package 'name' using the current
dnl selected package manager.
dnl If selected package manager isnt supported, would expand to an empty string
dnl 
define(ETC_PKG_UPDATE,`dnl
ifelse(ETC_PKG_MANAGER,brew,-brew upgrade $1,dnl
ifelse(ETC_PKG_MANAGER,apt-get,ETC_RUN_USER(`root',`apt-get -y upgrade $1'),dnl
ifelse(ETC_PKG_MANAGER,apt-fast,ETC_RUN_USER(`root',`apt-fast -y upgrade $1'),dnl
ifelse(ETC_PKG_MANAGER,pip,pip install --upgrade $1,dnl
ifelse(ETC_PKG_MANAGER,pip3,pip3 install --upgrade $1,dnl 
ifelse(ETC_PKG_MANAGER,gem,gem update $1,dnl 
ifelse(ETC_PKG_MANAGER,cpan,cpan-outdated -p | cpanm $1,)))))))')

dnl Usage: ETC_PKG_UPDATE(<name>)
dnl Expands to the command used to remove the package 'name' using the current
dnl selected package manager.
dnl If selected package manager isnt supported, would expand to an empty string
dnl 
define(ETC_PKG_REMOVE,`dnl
ifelse(ETC_PKG_MANAGER,brew,brew uninstall $1,dnl
ifelse(ETC_PKG_MANAGER,apt-get,ETC_RUN_USER(`root',`apt-get -y remove $1'),dnl
ifelse(ETC_PKG_MANAGER,apt-fast,ETC_RUN_USER(`root',`apt-fast -y remove $1'),dnl
ifelse(ETC_PKG_MANAGER,pip,pip uninstall $1,dnl
ifelse(ETC_PKG_MANAGER,pip3,pip3 uninstall $1,dnl
ifelse(ETC_PKG_MANAGER,gem,gem uninstall $1,dnl
ifelse(ETC_PKG_MANAGER,cpan,cpanm --uninstall $1,)))))))')

dnl Usage: ETC_PKG(<name>, [package manager])
dnl Maintain package by 'name' using the 'package manager'. If package manager
dnl is not specified, would use the current selected package manager.
dnl If the package by 'name' is not installed, would install package.
dnl If the package by 'name,' is outdated, would update package.
dnl If the remove target is called, would remove package.
dnl If the selected package manager is not installed, would expand to an empty
dnl string.
define(ETC_PKG,`dnl
ifelse(eval($# < 2),ETC_TRUE,`ETC_PKG($1,ETC_PKG_MANAGER)',`dnl
ifelse(ETC_PKG_SELECT($2),ETC_FALSE,,dnl
ETC_GEN_MAKE(ETC_BASENAME($1),`dnl
ETC_PKG_INSTALL($1)
',
`dnl
ETC_PKG_UPDATE($1)
',
`dnl
ETC_PKG_REMOVE($1)
')
`popdef(`ETC_PKG_MANAGER')')')')

#Git
dnl Usage: ETC_GIT_RETRIEVE('url', 'destination')
dnl Expands to the command retrieve the git repositiory pointed to at 'url'
dnl to the 'destination' filepath.
dnl
define(ETC_GIT_RETRIEVE, `git clone $1 $2')


dnl Usage: ETC_GIT_UPDATE(path)
dnl Expands to the command used to update the git repository at 'path'
dnl
define(ETC_GIT_UPDATE, `pushd $1; git pull -r $1; popd')

dnl Usage: ETC_GIT(<url>,<path>)
dnl Maintain git repositiory at path using git repositiory pointed to by 'url'
dnl 
define(ETC_GIT,`dnl
ETC_GEN_MAKE(ETC_BASENAME($2),`dnl
ETC_GIT_RETRIEVE($1,$2)
',
`dnl
ETC_GIT_UPDATE($2)
',
`dnl
rm -rf $2
')')

#Remote Resource
dnl Usage: ETC_RESOURCE(url, destination)
dnl Maintain remote resource at 'destination' using resource located at 'url'
dnl 
define(ETC_RESOURCE,`dnl
ETC_GEN_MAKE(ETC_BASENAME($2),`dnl
ETC_RETRIEVE($1,$2)
',
`dnl
rm -rf $2
ETC_RETRIEVE($1,$2)
',
`dnl
rm -rf $2
')')

#Local Hirarchy
dnl Usage: ETC_HIERARCHY(from, to)
dnl Maintain local path at 'to' using file hierarchy located at 'from'
dnl 
define(ETC_HIERARCHY,`dnl
ETC_GEN_MAKE(ETC_BASENAME($2),`dnl
cp -avf $1 $2
',
`dnl
rm -rf $2
cp -avf $1 $2
',
`dnl
rm -rf $2
')')

#Cleanup
undefine(`ETC_CURRENT_MODULE')
undefine(`ETC_PKG_MANAGER')

#Include Protection
define(`ETC_M4',ETC_TRUE)
) dnl INCLUDE PROTECTION DO NOT REMOVE

#Defaults
ETC_PKG_SELECT
)divert(0)dnl
