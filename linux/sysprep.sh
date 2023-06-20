#!/usr/bin/env bash

set -e

OMP_THEME=
GIT_VERSION=
NODE_VERSION=
PYTHON_VERSION=
MARIADB_VERSION=

BENCH_VERSION=
FRAPPE_VERSION=

APP_DIR=

ROOT_PASSWORD=
ADMIN_PASSWORD=

X_USER=
X_TOKEN=
X_REPO=

main() {
  if cat /etc/os-release | grep -q debian; then

    source ./scripts/utils.sh

    source ./scripts/debian/system.sh
    source ./scripts/debian/oh-my-posh.sh
    source ./scripts/debian/git.sh
    source ./scripts/debian/nvm.sh
    source ./scripts/debian/python.sh
    source ./scripts/debian/mariadb.sh

    source ./scripts/debian/frappe.sh

  fi

  if [ $# -eq 0 ]; then
    load_menu
  fi

  if [ $# -eq 1 ]; then
    "$1"
  fi
}

load_menu() {
  while true;
  do
    clear_screen
    print_header "Welcome to setup script"

    printf "1) Setup server\n"
    printf "2) Setup database\n"
    printf "3) Setup frappe\n"

    printf "Q) Quit\n\n"

    read -p "Choose an option: " option
    clear_screen

    case $option in
      1) 
        install_library && config &&
        install_git && install_nvm && install_python &&
        install_ohmyposh
        ;;
      2)
        install_redis && install_mariadb
        ;;
      3)
        install_bench && create_instance
        ;;
      q|Q)
        exit
        ;;
      *) 
        error "Invalid option"
        ;;
    esac
  done
}

main "$@"
