#!/bin/sh
#
# etcetera.sh
# Etc CLI
#

WORK_DIR=~/.etc/.etc_work

#Parse Options
while getopts "hfl:d:" opt
do
	case $opt in
		 h) 
			echo "Usage: etcetera [-hfld] (install|update|remove) [modules]"
			echo "install - install deployment"
			echo "update - update deployment"
			echo "remove - remove deployment"
			echo "-h - Print usage infomation"
			echo "-f - Force action, regardless if already installed or updated"
			echo "-l <nmodules> - Limit of how many modules to update at one time."
			echo "-d <ndays> - Check for updates only n days after last update."
            echo "[modules] - Interact with these modules only"
			exit 0;
		 ;;
		 f)
		 	rm -rf ~/.etc/.etc_work/mark/*
		 ;;
		 d)
			sed -e "/UPDATE_DELAY/s/[0-9]\{1,\}$/$OPTARG/" ~/.etc/makefile >/tmp/etc_makefile
			mv -f /tmp/etc_makefile ~/.etc/makefile
		 ;;
		 l)
			sed -e "/UPDATE_COUNT/s/[0-9]\{1,\}$/$OPTARG/" ~/.etc/makefile >/tmp/etc_makefile
			mv -f /tmp/etc_makefile ~/.etc/makefile
		 ;;
	esac
done

shift $((OPTIND -1))

SUBCOMMAND=$1
shift


#Read Modules 
MODULES=""
while [ $# -gt 0 ]
do
    MODULES="$MODULES $1"
    shift
done

MODULES=$(echo "$MODULES" | xargs) #Chomp whitespace

#Parse Subcommand
case $SUBCOMMAND in
	install)
        printf "\033[1m\033[0;32m[etcetera]: INSTALL BEGIN\033[0m\n"
        if [ $MODULES ]
        then
            for MODULE in $MODULES
            do
                time make -C ~/.etc/ install_$MODULE
            done
        else
            time make -C ~/.etc install
        fi
        printf "\033[1m\033[0;32m[etcetera]: INSTALL COMPLETE\033[0m\n"
		;;
	update)
		printf "\033[1m\033[0;32m[etcetera]: UPDATE BEGIN\033[0m\n"
        if [ $MODULES ]
        then
            for MODULE in $MODULES
            do
                time make -C ~/.etc/ update_$MODULE
            done
        else
            time make -C ~/.etc update
        fi
		printf "\033[1m\033[0;32m[etcetera]: UPDATE COMPLETE\033[0m\n"
		;;
	remove)
		printf "\033[1m\033[0;32m[etcetera]: REMOVAL BEGIN\033[0m\n"
        if [ $MODULES ]
        then
            echo "HERE"
            for MODULE in $MODULES
            do
                time make -C ~/.etc/ remove_$MODULE
            done
        else
            time make -i -C ~/.etc remove
        fi
		printf "\033[1m\033[0;32m[etcetera]: REMOVAL COMPLETE\033[0m\n"
		;;
	*)
		echo "Unknown subcommand: $1"
		exit 1
		;;
esac
