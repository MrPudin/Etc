#
# etc.m4
# Core Definitions 
# Etc Deployment System
# 

divert(-1)
#Constants
pushdef(TRUE, 1)
pushdef(FALSE, 0)
pushdef(PERROR,`errprint(__program__:__file__:__line__`:Error: $*
     ')m4exit(`1')')

#Operating System
define(ETC_OS_MACOS,Darwin)
define(ETC_OS_LINUX,Linux)
define(ETC_OS, `ifelse(syscmd(uname -S),$1,TRUE,FALSE)')

#Uility Macros
define(ETC_INSTALLED, `ifelse(syscmd(command -v $1),,FALSE,TRUE)')
define(ETC_EXISTS, `syscmd(test -e $1)ifelse(sysval,0,TRUE,FALSE)')

dnl Usage: ETC_SELECT_BEGIN(<name>)
dnl .... <use make macros using selection> ...
dnl ETC_SELECT_END(<name>)
dnl
define(ETC_SELECT_BEGIN,`pushdef(ETC_SELECTION,$1)')
define(ETC_SELECT_END,`popdef(ETC_SELECTION,$1)')

#Make Macros

dnl Usage: ETC_TARGET([<name>])
dnl Expands to the marker path of 'name', if 'name' is obmitted, gives marker
dnl path of current selection.
dnl
define(ETC_TARGET,`
ifelse(eval($# < 1),TRUE,ETC_TARGET(ETC_SELECTION()),dnl
.etc/mark_$1)')

dnl Usage: ETC_DEPEND(<dependency>,[<dependent>])
dnl Makes 'dependent' depend on 'dependency'
dnl if 'name' is obmitted, makes current selection depend on 'dependency'
dnl
define(ETC_DEPEND,`
ifelse(eval($# > 1),TRUE,ETC_TARGET($1): ETC_TARGET($2),dnl
ETC_SELECTION(): ETC_TARGET($1))')

dnl Usage: ETC_MARK(<name>)
dnl Marks 'name' status as completed and fullfills any dependency created by
dnl 'name'
dnl
define(ETC_MARK,`dnl
ifelse(eval($# < 1),TRUE,ETC_MARK(ETC_SELECTION()),dnl
syscmd(touch -f ETC_TARGET($1)))'))

dnl Usage: ETC_MARK(<name>)
dnl Marks 'name' status as incomplete and unfullfills any dependency created by
dnl 'name'
dnl
define(ETC_UNMARK,`dnl
ifelse(eval($# < 1),TRUE,ETC_UNMARK(ETC_SELECTION()),dnl
syscmd(rm -f ETC_TARGET($1)))')

#Conditionals
dnl Usage: ETC_IF_OS(<OS>,<TRUE>,<FALSE>)
dnl Expands to 'TRUE' if current Operating System is indeed 'OS', else expands
dnl to 'FALSE'.
dnl
define(ETC_IF_OS,`ifelse(ETC_OS($1),TRUE,$2,$3)')

dnl Usage: ETC_IF_OS(<OS>,<TRUE>,<FALSE>)
dnl Expands to 'TRUE' if 'name' is installed else expands to 'FALSE'.
dnl
define(ETC_IF_INSTALLED,`ifelse(ETC_INSTALLED($1),TRUE,$2,$3)')

#Fetch Macros

dnl Usage: ETC_RETRIEVE('url', 'destination')
dnl Attempts to retrieve the resource pointed to at 'url' to the filepath at
dnl 'destination'
dnl
define(ETC_RETRIEVE,'dnl
ifelse(ETC_INSTALLED(aria2c),TRUE,aria2c -x 10 -s 10 -o $2 $1
ifelse(ETC_INSTALLED(curl),TRUE,curl -o $2 $1))')

dnl Usage: ETC_RETRIEVE_GIT('url', 'destination')
dnl Attempts to retrieve the git repositiory pointed to at 'url' to the 
dnl filepath at 'destination'
dnl
define(ETC_RETRIEVE_GIT, `git clone $1 $2')


dnl Usage: ETC_RETRIEVE(<path>)
dnl Extract .tar.gz pointed by 'path' to the current directory.
dnl
define(ETC_EXTRACT_TGZ, `tar -xzf $1')

#Methods
#Package Manager 
dnl Usage: ETC_PKG_SELECT([brew|apt-get|apt-fast|pip])
dnl Select the package manager referenced by 'name' for use.
dnl If argument is obmitted, reset package manager selection to default.
dnl
define(ETC_PKG_SELECT,`dnl
ETC_IF_INSTALLED(brew, `define(ETC_PKG_MANAGER, brew)',dnl
ETC_IF_INSTALLED(apt-get, `define(ETC_PKG_MANAGER, apt-get)',dnl
ETC_IF_INSTALLED(apt-fast, `define(ETC_PKG_MANAGER, apt-fast)',dnl
PERROR("Package Manager not supported. Edit etc.m4 to add support))))
')

dnl Usage: ETC_PKG_INSTALL(<name>)
dnl Expands to the command used to install the package 'name' using the current
dnl selected package manager.
dnl 
define(ETC_PKG_INSTALL,`dnl
ifelse(ETC_PKG_MANAGER,brew,brew install $1,dnl
ifelse(ETC_PKG_MANAGER,apt-get,sudo apt-get -y install $1,dnl
ifelse(ETC_PKG_MANAGER,apt-fast,sudo apt-fast -y install $1,dnl
ifelse(ETC_PKG_MANAGER,pip,pip install $1,dnl
PERROR("Package Manager not supported. Edit etc.m4 to add support)))))
')

dnl Usage: ETC_PKG_UPDATE(<name>)
dnl Expands to the command used to update the package 'name' using the current
dnl selected package manager.
dnl 
define(ETC_PKG_UPDATE,`dnl
ifelse(ETC_PKG_MANAGER,brew,brew update; brew upgrade $1,dnl
ifelse(ETC_PKG_MANAGER,apt-get,sudo apt-get -y update; sudo apt-get -y upgrade $1,dnl
ifelse(ETC_PKG_MANAGER,apt-fast,sudo apt-fast -y update; sudo apt-fast -y upgrade $1,dnl
ifelse(ETC_PKG_MANAGER,pip,pip install --upgrade,dnl
PERROR("Package Manager not supported. Edit etc.m4 to add support)))))
')

dnl Usage: ETC_PKG_UPDATE(<name>)
dnl Expands to the command used to remove the package 'name' using the current
dnl selected package manager.
dnl 
define(ETC_PKG_REMOVE,`dnl
ifelse(ETC_PKG_MANAGER,brew,brew uninstall $1,dnl
ifelse(ETC_PKG_MANAGER,apt-get,sudo apt-get -y remove $1,dnl
ifelse(ETC_PKG_MANAGER,apt-fast,sudo apt-fast -y remove $1,dnl
ifelse(ETC_PKG_MANAGER,pip,pip uninstall $1,
PERROR("Package Manager not supported. Edit etc.m4 to add support)))))
')

dnl Usage: ETC_PKG(<name>)
dnl Maintain package by 'name' using the current selected package manager.
dnl If the package by 'name' is not installed, would install package.
dnl If the package by 'name,' is outdated, would update package.
dnl If the remove target is called, would remove package.
dnl 
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
dnl Usage: ETC_AUTL_INSTALL(<path>)
dnl Expands to the commands used to install the package 'name' using Autotools
dnl from source to at 'path'
dnl 
define(ETC_AUTL_INSTALL,`dnl
pushd $1
ETC_EXTRACT_TGZ(*)
./configure
make
sudo make install
popd')

#TODO: Add support for checking last updated.

dnl Usage: ETC_AUTL_REMOVE(<path>)
dnl Expands to the commands used to remove the package 'name' using Autotools.
dnl from source to at 'path'
dnl 
define(ETC_AUTL_REMOVE, `dnl
pushd $1
make uninstall
popd
rm -rf $1')

dnl Usage: ETC_AUTL(<name>,<url>,[<path>])
dnl Maintain 'name' using Autotool source pointed to by 'url'
dnl If 'path' is not obmitted, move the source under 'path' directory
dnl If 'name' is not installed, would install 'name' from source.
dnl If 'name' update target is called, would reinstall 'name' from source
dnl If the remove target is called, would remove 'name' using source.
dnl 
define(ETC_AUTL,`dnl
ifelse(eval($# < 3),TRUE,ETC_AUTL($1, $2, .etc/autl-$1),dnl
.PHONY: install update remove
install: ETC_TARGET($1)
update:
	ETC_RETRIEVE($2, `$3/$1.tgz')
	ETC_AUTL_INSTALL($3)
	ETC_MARK($1)
remove:
	ETC_AUTL_REMOVE($3)
	ETC_UNMARK($1)
ETC_TARGET($1):
	@mkdir $3
	ETC_RETRIEVE($2, `$3/$1.tgz')
	ETC_AUTL_INSTALL($3)
	ETC_MARK($1)
)')


#Git
dnl Usage: ETC_GIT(<name>,<url>,[<path>])
dnl Maintain 'name' using git repositiory pointed to by 'url'
dnl If 'path' is not obmitted, move the git repositiory under 'path' directory
dnl If 'name' is not installed, would install 'name' from source.
dnl If 'name' update target is called, would reinstall 'name' from source
dnl If the remove target is called, would remove 'name' using source.
dnl 
define(ETC_GIT,`dnl
ifelse(eval($# < 3),TRUE,ETC_GIT($1, $2, .etc/git-$1/),dnl
.PHONY: install update remove
install: ETC_TARGET($1)
	ETC_MARK($1)
update:
	ETC_RETRIEVE_GIT($2, `$3/$1')
	ETC_MARK($1)
remove:
	rm -rf 1$3/$1'
	ETC_UNMARK($1)
ETC_TARGET($1):
	@mkdir $3
	ETC_RETRIEVE_GIT($2, `$3/$1')
	ETC_MARK($1)
)')

#Cleanup
popdef(TRUE)
popdef(FALSE)
popdef(PERROR)
undefine(ETC_SELECTION)
undefine(ETC_PKG_MANAGER)
divert(0)

#Setup Default

ETC_PKG_SELECT() #Select Default Package Manager
