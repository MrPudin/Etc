#!/bin/sh
#
# etcetera.sh
# Etc CLI
#

ETC_DIR="${ETC_DIR-"$HOME/.etc"}"
WORK_DIR="$ETC_DIR/.etc_work"
MAKE_ARG="-C $WORK_DIR"
FORCE=false

#Parse Options
while getopts "hfl:d:" opt
do
	case $opt in
		 h) 
			echo "Usage: etcetera [-hf] (install|update|remove) [modules]"
			echo "install - install deployment"
			echo "update - update deployment"
			echo "remove - remove deployment"
			echo "-h - Print usage infomation"
			echo "-f - Force action, regardless if already action already completed, or if there are any errors"
            echo "[modules] - Limit scope within modules only"
			exit 0;
		 ;;
		 f)
            FORCE=true
		 ;;
	esac
done

shift $((OPTIND -1))

SUBCOMMAND=$1
shift

#Read Modules 
MODULES="$*"

#Setup Workspace
make -C "$ETC_DIR" install &>/dev/null

#Preprocess Markers
if $FORCE
then
    MAKE_ARG="$MAKE_ARG -i"
    
    if [ $MODULES ]
    then
        for MODULE in $MODULES
        do
            rm -f $WORK_DIR/mark/$MODULE*
        done
    else
        rm -rf $WORK_DIR/mark
        mkdir -p $WORK_DIR/mark
        MAKE_ARG="$MAKE_ARG UPDATE_DELAY:=0 UPDATE_COUNT:=999999"
    fi
fi

#Parse Subcommand
case $SUBCOMMAND in
	install)
        printf "\033[1m\033[0;32m[etcetera]: INSTALL BEGIN\033[0m\n"
        if [ "$MODULES" ]
        then
            for MODULE in $MODULES
            do
                time make $MAKE_ARG install_$MODULE
            done
        else
            time make $MAKE_ARG install
        fi
        printf "\033[1m\033[0;32m[etcetera]: INSTALL COMPLETE\033[0m\n"
		;;
	update)
		printf "\033[1m\033[0;32m[etcetera]: UPDATE BEGIN\033[0m\n"

        pushd "$ETC_DIR"
        git pull -r
        popd

        if [ "$MODULES" ]
        then
            for MODULE in $MODULES
            do
               time make $MAKE_ARG update_$MODULE
                
            done
        else
            time make $MAKE_ARG update
        fi
		printf "\033[1m\033[0;32m[etcetera]: UPDATE COMPLETE\033[0m\n"
		;;
	remove)
		printf "\033[1m\033[0;32m[etcetera]: REMOVAL BEGIN\033[0m\n"
        if [ "$MODULES" ]
        then
            for MODULE in $MODULES
            do
                time make -i $MAKE_ARG remove_$MODULE
            done
        else
            time make -i $MAKE_ARG remove
        fi
		printf "\033[1m\033[0;32m[etcetera]: REMOVAL COMPLETE\033[0m\n"
		;;
	*)
		echo "Unknown subcommand: $1"
		exit 1
		;;
esac
