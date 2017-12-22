#
# etc.m4
# Core Definitions 
# Etc Deployment System
# 

divert(-1)
#Constants
pushdef(TRUE, 1)
pushdef(FALSE, 0)

#Operating System
define(ETC_OS_MACOS,Darwin)
define(ETC_OS_LINUX,Linux)
define(ETC_OS, `ifelse(syscmd(uname -S),$1,TRUE,FALSE)')

#Uility Macros
define(ETC_INSTALLED, `ifelse(syscmd(command -v $1),,FALSE,TRUE)')fa
define(ETC_EXISTS, 'syscmd(test -e $1)ifelse(sysval,0,TRUE,FALSE)')
define(ETC_SELECT_BEGIN,`pushdef(ETC_SELECTION,$1)')
define(ETC_SELECT_END,`popdef(ETC_SELECTION,$1)')

#Make Macros
define(ETC_TARGET,`
ifelse(eval($# < 1),TRUE,ETC_TARGET(ETC_SELECTION()),dnl
.etc/mark_$1)')

define(ETC_DEPEND,`
ifelse(eval($# > 1),TRUE,ETC_TARGET($1): ETC_TARGET($2),dnl
ETC_SELECTION(): ETC_TARGET($1))')

define(ETC_MARK,`dnl
ifelse(eval($# < 1),TRUE,ETC_MARK(ETC_SELECTION()),dnl
syscmd(touch -f ETC_TARGET($1)))'))

define(ETC_UNMARK,`dnl
ifelse(eval($# < 1),TRUE,ETC_UNMARK(ETC_SELECTION()),dnl
syscmd(rm -f ETC_TARGET($1)))')

#Conditionals
define(ETC_IF_OS,`ifelse(ETC_OS($1),TRUE,$2)')
define(ETC_IF_INSTALLED,`ifelse(ETC_INSTALLED($1),TRUE,$2)')

#Fetch Macros
define(ETC_RETRIEVE,`dnl
ifelse(ETC_INSTALLED(aria2c),TRUE,aria2c -x 10 -s 10 -o $2 $1
ifelse(ETC_INSTALLED(curl),TRUE,curl -o $2 $1))')

define(ETC_RETRIEVE_GIT, `git clone $1 $2')

define(ETC_EXTRACT_TGZ, `tar -xzf $1')

#Methods
#Package Manager 
define(ETC_PKG_SELECT,`dnl
ifelse(eval($#>1),TRUE,ETC_IF_INSTALLED($1, `define(ETC_PKG_MANAGER,$1)'))dnl
ETC_IF_INSTALLED(brew, `define(ETC_PKG_MANAGER, brew)')dnl
ETC_IF_INSTALLED(apt-get, `define(ETC_PKG_MANAGER, apt-get)')dnl
ETC_IF_INSTALLED(apt-fast, `define(ETC_PKG_MANAGER, apt-fast)')')

define(ETC_PKG_INSTALL,`dnl
ifelse(ETC_PKG_MANAGER,brew,brew install $1,dnl
ifelse(ETC_PKG_MANAGER,apt-get,sudo apt-get -y install $1,dnl
ifelse(ETC_PKG_MANAGER,apt-fast,sudo apt-fast -y install $1,dnl
ifelse(ETC_PKG_MANAGER,pip,pip install $1))))dnl
')

define(ETC_PKG_UPDATE,`dnl
ifelse(ETC_PKG_MANAGER,brew,brew update; brew upgrade $1,dnl
ifelse(ETC_PKG_MANAGER,apt-get,sudo apt-get -y update; sudo apt-get -y upgrade $1,dnl
ifelse(ETC_PKG_MANAGER,apt-fast,sudo apt-fast -y update; sudo apt-fast -y upgrade $1,dnl
ifelse(ETC_PKG_MANAGER,pip,pip install --upgrade))))
')

define(ETC_PKG_REMOVE,`dnl
ifelse(ETC_PKG_MANAGER,brew,brew uninstall $1,dnl
ifelse(ETC_PKG_MANAGER,apt-get,sudo apt-get -y remove $1,dnl
ifelse(ETC_PKG_MANAGER,apt-fast,sudo apt-fast -y remove $1,dnl
ifelse(ETC_PKG_MANAGER,pip,pip uninstall $1))))dnl
')

define(ETC_PKG,'dnl
.PHONY: install update remove
install: ETC_TARGET($1)
update:
	ETC_PKG_UPDATE($1)
	ETC_MARK($1)
remove:
	ETC_PKG_REMOVE($1)
	ETC_UNMARK($1)
ETC_TARGET($1):
	ETC_PKG_INSTALL($1)
	ETC_MARK($1)
')

#Autotools
define(ETC_AUTL_INSTALL,`dnl
rm -rf `.etc/build-$1'
ETC_RETRIEVE($1, `.etc/build-$1.tgz')
pushd `.etc/build-$1'
./configure
make
sudo make install
popd')

#TODO: Add support for checking last updated.
define(ETC_AUTL_UPDATE,`dnl
rm -rf .etc/build-$1
ETC_RETRIEVE($1, `.etc/build-$1')
pushd .etc/build-$1
./configure
make
sudo make install
popd')

define(ETC_AUTL_REMOVE, `dnl
pushd $1
make uninstall
popd
rm -rf .etc/build-$1')


define(ETC_AUTL,'dnl
install: ETC_TARGET($1)
update:
	ETC_AUTL_UPDATE($1)
	ETC_MARK($1)
remove:
	ETC_AUTL_REMOVE($1)
	ETC_UNMARK($1)
ETC_TARGET($1):
	ETC_AUTL_INSTALL($1)
	ETC_MARK($1)
')

#Cleanup
popdef(TRUE)
popdef(FALSE)
undefine(ETC_SELECTION)

divert(0)

#Setup Default

ETC_PKG_SELECT() #Select Default Package Manager
