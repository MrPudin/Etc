divert(-1)dnl
ifdef(`ETC_UTIL_M4',, dnl Include Protection
dnl 
dnl src/etc_util.m4
dnl Core Utilties
dnl Etcetera deployment system 
dnl 

#Constants
define(ETC_TRUE, 1)
define(ETC_FALSE, 0)
define(ETC_OS_MACOS,`Darwin') dnl Operating System name for Mac OSs
define(ETC_OS_LINUX,`Linux') dnl Operation System name for Linux OSs

# Utilities
dnl Usage: ETC_CHOMP(<expr>)
dnl Expands to the given 'expr' with the trailing whitespace removed
define(ETC_CHOMP,`patsubst($1,`\s*$',)')

dnl Usage: ETC_BASENAME(<path>)
dnl Expands to the filename portion of path.
define(ETC_BASENAME,`patsubst($1,`^.*/',)') dnl remove until last '/'

dnl Usage: ETC_MAKE_INDENT(<lines>)
dnl Expands the given 'lines seperated by a single \n, to lines seperated by \t\n
dnl This indentation is needed for makefile target building commands
define(ETC_MAKE_INDENT,`patsubst($1,`
',`
	')')

dnl Usage: ETC_IS_INSTALLED(<cmd>)f
dnl Check if the given 'cmd' is installed and accessible using the current PATH.
dnl Expands to ETC_TRUE if installed, else ETC_FALSE

define(ETC_IS_INSTALLED, `dnl 
syscmd(command -v $1)dnl
ifelse(sysval,0,ETC_TRUE(),ETC_FALSE())dnl sysval expands to exit code of syscmd
')

define(ETC_EXISTS, `dnl
syscmd(test -e $1)dnl
ifelse(sysval,0,ETC_TRUE,ETC_FALSE)dnl sysval expands to exit code of syscmd
')

# User Permissions
dnl Usage: ETC_REAL_USER
dnl Expands to the username of the real user.
define(ETC_REAL_USER,`ETC_CHOMP(esyscmd(id -run))')

dnl Usage: ETC_RUN_USER(<username>, <cmd>)
dnl Expands to command that will run the given command as the given user
dnl This is userful to run a command that requires specific user permissions such as root.
define(ETC_RUN_USER, `su $1 -c "$2"')

dnl Usage: ETC_RUN_NORMAL(<cmd>)
dnl Run the given command as the real user.
dnl Useful for dropping superuser permissions.
define(ETC_RUN_NORM, `ETC_RUN_USER(ETC_REAL_USER(),`$1')')

dnl Usage: ETC_RUN_SUDO(<cmd>)
dnl Run the given command as the superuser
define(ETC_RUN_SUDO, `ETC_RUN_USER(`root',`$1')')

# Retrieve Macros
dnl Usage: ETC_RETRIEVE('url', 'destination')
dnl Attempts to retrieve the resource pointed to at 'url' to the filepath at
dnl 'destination' using the most optimal retrieval program.
define(ETC_RETRIEVE,`ETC_RUN_NORM(`curl -fLo $2 --create-dirs $1')')

# Target Markers
dnl Usage: ETC_TARGET_MARKER(<name>)
dnl Expands to the target marker file path of the target 'name': 
dnl  <current module name>__<name of target>
define(ETC_TARGET_MARKER,``mark/'ETC_CURRENT_MODULE()`__$1'')

dnl Usage: ETC_MARK(<name>)
dnl Marks 'name' status as completed and fullfills any dependency created by
dnl 'name'
dnl
define(ETC_MARK,`ETC_RUN_NORM(`touch -f ETC_TARGET_MARKER($1)')')

dnl Usage: ETC_UNMARK([name])
dnl Marks 'name' status as incomplete and unfullfills any dependency created by
dnl 'name'
define(ETC_UNMARK,`ETC_RUN_NORM(`rm -f ETC_TARGET_MARKER($1)')')

define(`ETC_UTIL_M4',ETC_TRUE)
) dnl Include Proctection
divert(0)dnl
