#!/usr/bin/env bash

set -e

RUNNING_DIR=$(dirname -- $0)

# This is the configuration for setup frappe environment
BENCH_VERSION= #5.16.4
FRAPPE_VERSION= #version-14

APP_DIR= #~/opt

DB_HOST= #127.0.0.1
DB_ROOT_USERNAME= #super_user_on_db_server
DB_ROOT_PASSWORD= #password_of_super_user

FRAPPE_ADMIN_PASSWORD= #super_secure_password

X_USER= #your_user
X_TOKEN= #your_token
X_REPO= #repo.servername.com

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

    source ./scripts/debian/frappe.sh

  fi

  if [ $# -eq 0 ]; then
    load_menu
  fi

  if [ $# -eq 1 ]; then
    "$1"
  fi
}

main "$@"
