#!/usr/bin/env bash

set -e

RUNNING_DIR=$(dirname -- $0)

main() {
  if cat /etc/os-release | grep -q debian; then

    source ./menu.sh
    source ./scripts/utils.sh
  
    if [ -z $RUNNING_DIR/sysprep.env ]; 
    then 
      error "File sysprep.env is missing. Please check and try again."
      exit 2
    else
      source $RUNNING_DIR/sysprep.env;    
    fi
    
    source $RUNNING_DIR/scripts/debian/system.sh
    source $RUNNING_DIR/scripts/debian/oh-my-posh.sh
    source $RUNNING_DIR/scripts/debian/git.sh
    source $RUNNING_DIR/scripts/debian/nvm.sh
    source $RUNNING_DIR/scripts/debian/python.sh
    source $RUNNING_DIR/scripts/debian/mariadb.sh

  fi

  if [ $# -eq 0 ]; then
    load_menu
  fi

  if [ $# -eq 1 ]; then
    "$1"
  fi
}

main "$@"
