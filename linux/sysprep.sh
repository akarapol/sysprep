#!/usr/bin/env bash

set -e

OMP_THEME=
GIT_VERSION=
NODE_VERSION=
PYTHON_VERSION=
MARIADB_VERSION=

main() {
  if cat /etc/os-release | grep -q debian; then

    source ./scripts/utils.sh

    source ./scripts/debian/system.sh
    source ./scripts/debian/oh-my-posh.sh
    source ./scripts/debian/git.sh
    source ./scripts/debian/nvm.sh
    source ./scripts/debian/python.sh
    source ./scripts/debian/mariadb.sh

  fi

  if [ $# -eq 1 ]; then
    "$1"
  fi
}

main "$@"
