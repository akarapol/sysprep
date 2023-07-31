#!/usr/bin/env bash

set -e

# This is the configuration for development environment
OMP_THEME= #honukai
GIT_VERSION= #2.41.0
NODE_VERSION= #18.15.0
PYTHON_VERSION= #3.11.0
MARIADB_VERSION= #10.6

main() {
  if cat /etc/os-release | grep -q debian; then

    source ./menu.sh
    source ./scripts/utils.sh

    source ./scripts/debian/system.sh
    source ./scripts/debian/oh-my-posh.sh
    source ./scripts/debian/git.sh
    source ./scripts/debian/nvm.sh
    source ./scripts/debian/python.sh
    source ./scripts/debian/mariadb.sh

  fi

  if [ $# -eq 0 ]; then
    load_menu
  fi

  if [ $# -eq 1 ]; then
    "$1"
  fi
}

main "$@"
