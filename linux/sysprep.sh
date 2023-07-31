#!/usr/bin/env bash

set -e

# This is the configuration for development environment
OMP_THEME= #honukai
GIT_VERSION= #2.41.0
NODE_VERSION= #18.15.0
PYTHON_VERSION= #3.11.0
MARIADB_VERSION= #10.6

# This is the configuration for setup frappe environment
BENCH_VERSION= #5.16.4
FRAPPE_VERSION= #version-14

APP_DIR= #~/opt

ROOT_PASSWORD= #super_secure_password
ADMIN_PASSWORD= #super_secure_password

X_USER= #your_user
X_TOKEN= #your_token
X_REPO= #repo.servername.com

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
