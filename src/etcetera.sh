#!/bin/sh
#
# etcetera.sh
# Etc CLI
#

# Etcetera directory is define as ~/.etc by default if not already specified as
# enviromental variable
export ETC_DIR="${ETC_DIR-$HOME/.etc}"
DEPLOYMENT_PATH="$ETC_DIR/deploy/deployment.etc"
MAKE_ARG=""
FORCE=false

#Parse Options
while getopts "hfd:" opt
do
	case $opt in
		 h) 
			echo "Usage: etcetera [-hi] [-d <deployment>] (install|update|remove) [modules]"
			echo "install - install deployment"
			echo "update - update deployment"
			echo "remove - remove deployment"
			echo "-h - Print usage infomation"
            echo "-i - Ignore any errors, just continue"
            echo "-d - specify the deployment file to use, otherwise uses '~/.etc/deploy/deployment.etc'"
            echo "[modules] - Limit deployment scope to within these modules only"
			exit 0;
		 ;;
         i)
            MAKE_ARG="$MAKE_ARG -i"
         ;;
         d)
            DEPLOYMENT_PATH="$OPTARG"
         ;;
	esac
done

shift $((OPTIND -1))

# Parse subcommand
SUBCOMMAND=$1
shift

# Read Modules - limits the scope of the subcommand over modules
# if modules are specifed, subcommand will only operate on the specified modles
MODULES="$*" 

# Contruct working directory
WORK_DIR="$ETC_DIR/.work"
mkdir -p "$WORK_DIR"

# Generate deployment makefile from ETC deployment specification
# Test if deployment specification is newer than deployment makefile
# Triggers a regeneration of deployment makefile if older or if makefile does not exist
DEPLOY_MK_PATH="$WORK_DIR/deployment.mk"

if test ! -e "$DEPLOY_MK_PATH" -o -n "$(find -L -- $DEPLOYMENT_PATH -prune -newer $DEPLOY_MK_PATH 2>/dev/null)"
then
    echo "[etcetera]: Generating Build Script..."
    m4 --include="$ETC_DIR/src" "$DEPLOYMENT_PATH" >"$DEPLOY_MK_PATH"
fi

MAKE_ARG="-f $DEPLOY_MK_PATH $MAKE_ARG"

#Execute Subcommand
case $SUBCOMMAND in
	install)
        printf "\033[1m\033[0;32m[etcetera]: Installing...\033[0m\n"

        if [ "$MODULES" ] 
        then
            for MODULE in $MODULES
            do
                # Trigger installation instructions for the module only
                # Full operation also triggers instructions for dependecies
                time make $MAKE_ARG "full_install__$MODULE"
            done
        else
            time make $MAKE_ARG install # Trigger installation of entire deployment
        fi
        printf "\033[1m\033[0;32m[etcetera]: Installed.\033[0m\n"
		;;
	update)
		printf "\033[1m\033[0;32m[etcetera]: Updating...\033[0m\n"

        if [ "$MODULES" ]
        then
            for MODULE in $MODULES
            do
                # Trigger update instructions for the module only
                # Full operation also triggers instructions for dependecies
                time make $MAKE_ARG "full_update__$MODULE"
            done
        else
            time make $MAKE_ARG update # Trigger upgrade of entire deployment
        fi
		printf "\033[1m\033[0;32m[etcetera]: Updated.\033[0m\n"
		;;
	remove)
		printf "\033[1m\033[0;32m[etcetera]: Removing...\033[0m\n"

        if [ "$MODULES" ]
        then
            for MODULE in $MODULES
            do
                # Trigger removal instructions for the module only
                # Full operation also triggers instructions for dependecies
                time make $MAKE_ARG "full_remove__$MODULE"
            done
        else
            time make $MAKE_ARG remove # Trigger removal of entire deployment
        fi
		printf "\033[1m\033[0;32m[etcetera]: Removed.\033[0m\n"
		;;
	*)
		echo "Unknown subcommand: $SUBCOMMAND"
		exit 1
		;;
esac
