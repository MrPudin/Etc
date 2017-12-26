#!/bin/sh
#
# etcetera.sh
# Etc CLI
#

while (( "$#" ))
do
    case $1 in
        install)
            make -C ~/.etc install
			shift
            ;;
        update)
            make -C ~/.etc update
			shift
            ;;
        remove)
            make -C ~/.etc remove
			shift
            ;;
        *)
            echo "Unknown subcommand: $1"
            echo "Usage: etcetera (install|update|remove)"
			exit 1;
            ;;
    esac
done
