divert(-1)dnl

ifdef(`ETC_UTIL_M4',,`dnl Include Protection
dnl 
dnl src/etc_util.m4
dnl Core Utilties
dnl Etcetera deployment system 
dnl 


# Utilities
dnl Usage: ETC_CHOMP(<expr>)
dnl Expands to the given 'expr' with the trailing and lead whitespace removed
define(ETC_CHOMP,`patsubst(patsubst(`$1',`^\s*',),`\s*$',)')

#Constants
define(`ETC_TRUE',1)
define(`ETC_FALSE',0)
define(`ETC_DEPLOY_DIR',`./deploy')

# Utils cont.
dnl Usage: ETC_BASENAME(<path>)
dnl Expands to the filename portion of path.
define(ETC_BASENAME,`patsubst($1,`^.*/',)')dnl remove until last '/'

dnl Usage: ETC_MAKE_INDENT(<lines>)
dnl Expands the given 'lines seperated by a single \n, to lines seperated by \t\n
dnl This indentation is needed for makefile target building commands
define(ETC_MAKE_INDENT,`patsubst($1,`
',`
	')')

dnl Usage: ETC_FILTER_COMMENT(<expr>)
dnl Expands to the given expression 'expr' without comments.
dnl Comments are defined are strings that begin with '#' and end with '\n'
define(ETC_FILTER_COMMENT, `patsubst(`$1',`#.*
',`')')

dnl Usage: ETC_FILTER_EMPTY_LINE(<expr>)
dnl Expands to the given expresssion
define(ETC_FILTER_EMPTY_LINE,`patsubst(`$1',`

',`')')

dnl Usage: ETC_ESCAPE_DQUOTE(<expr>)
dnl Expands to the given expression 'expr' with the double quotes (") escaped
dnl (\").
define(ETC_ESCAPE_DQUOTE,`patsubst(`$1',`"',`\\"')')

dnl Usgae: ETC_READ(<filepath>)
dnl Expands to the contents of the file at `filepath'
define(ETC_READ,`esyscmd(cat "`$1'")')

dnl Usage: ETC_GREP(<pattern>,<expr>)
dnl Expands to the first line that matches the pattern in the given expression
define(ETC_GREP, `esyscmd(printf "ETC_ESCAPE_DQUOTE(`$2')" | grep "$1" | head -n 1)')

dnl Usage: ETC_SLICE(<delmiter>,<nfield>,<expr>)
dnl Expands to the the 'nfield' field delimted by 'delmiter' in expression 'expr'
define(ETC_SLICE, `esyscmd(printf "ETC_ESCAPE_DQUOTE(`$3')" | cut -f $2 -d "`$1'")')

dnl Usage: ETC_LINE(<line_no>,<expr>)
dnl Expands to the specifed line by the given line number of the given expression 'expr'
dnl Line indexing starts from 1 for the first line.
define(ETC_LINE,`esyscmd(printf "ETC_ESCAPE_DQUOTE(`$2')" | tail -n +$1 | head -n 1)')

dnl Usage ETC_LINE_COUNT(<expr>)
dnl Expands to the line count of the expression
define(ETC_LINE_COUNT,`ETC_CHOMP(esyscmd(printf "ETC_ESCAPE_DQUOTE(`$1')" | wc -l))')

dnl Usage: ETC_IS_INSTALLED(<cmd>)
dnl Check if the given 'cmd' is installed and accessible using the current PATH.
dnl Expands to ETC_TRUE if installed, else ETC_FALSE
define(ETC_IS_INSTALLED,`dnl 
ifelse(esyscmd(command -v $1),,ETC_FALSE,ETC_TRUE)')

define(ETC_EXISTS,`dnl
syscmd(test -e $1)dnl
ifelse(sysval,0,ETC_TRUE,ETC_FALSE)')

define(ETC_OS,`ETC_CHOMP(esyscmd(`uname -s'))')

# User Permissions
dnl Usage: ETC_REAL_USER
dnl Expands to the username of the real user.
define(`ETC_REAL_USER',`ETC_CHOMP(esyscmd(logname))')

dnl Usage: ETC_RUN_USER(<username>, <cmd>)
dnl Expands to command that will run the given command as the given user
dnl This is userful to run a command that requires specific user permissions such as root.
dnl The cmd will be escaped to ensure that double quoting is passed properly
define(ETC_RUN_USER, `su $1 -c "ETC_ESCAPE_DQUOTE(`$2')"')

dnl Usage: ETC_RUN_NORMAL(<cmd>)
dnl Run the given command as the real user.
dnl Useful for dropping superuser permissions.
define(ETC_RUN_NORM, `ETC_RUN_USER(ETC_REAL_USER(),`$1')')

dnl Usage: ETC_RUN_SUDO(<cmd>)
dnl Run the given command as the superuser
define(ETC_RUN_SUDO, `ETC_RUN_USER(`root',`$1')')

dnl Usage ETC_SUDO(<implmentation>)
dnl Run the given 'implementation' consisting of ETC_RUN macros using the superuser.
define(ETC_SUDO,`define(`ETC_FLAG_SUDO',1)dnl
$1dnl
undefine(`ETC_FLAG_SUDO')dnl
')

dnl Usage: ETC_RUN(<cmd>)
dnl Run the given command based whether the flag ETC_FLAG_SUDO is defined.
dnl If it is defined, run the command as superuser, else run it as normal user.
define(ETC_RUN, `ifdef(`ETC_FLAG_SUDO',dnl
ETC_RUN_SUDO(`$1'),dnl
ETC_RUN_NORM(`$1'))dnl
')

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

define(`ETC_UTIL_M4',1)
')dnl Include Proctection
divert(0)dnl
