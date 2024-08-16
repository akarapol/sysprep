#!/usr/bin/env bash
set -eu

RUNNING_DIR=$(dirname -- "${0}")
S_ARGS=
X_ARGS=

# ************************************************************ #
# USER VARIABLES                                               #
# ************************************************************ #
GIT_VERSION= #"2.43.0"
NODE_VERSION= #"20.11.0"
PYTHON_VERSION= #"3.12.0"
MARIADB_VERSION= #"10.11"

# ************************************************************ #
# MAIN PROGRAM                                                 #
# ************************************************************ #
display_help() {
  printf "Usage: run.sh [OPTIONS] [ARGS] \n\n"
  printf "OPTIONS:\n"
  printf "  -h      Display this help message.\n"
  printf "  -s      Setup Server.\n"
  printf "    core          Basic configuration.\n"
  printf "    mariadb       MiariaDB server.\n"
  printf "    dev           Frappe Development server.\n"
  printf "    aio           Frappe All-in-one server.\n"
  printf "    app           Frappe App server.\n"
  printf "  -x     Run specific function (update_system, install_lazygit, etc... ).\n\n"
  printf "Examples:\n"
  printf "  ./run.sh -h\n"
  printf "  ./run.sh -t dev\n"
  printf "  ./run.sh -x update_system\n"

  exit 0
}

main() {
  if [ -f "${RUNNING_DIR}/.env" ]; then
    source "${RUNNING_DIR}/.env"
  fi

  while getopts ":hs:x:" opt; do
    case $opt in
      h)
        clear_screen
        display_help
        ;;
      s)
        S_ARGS=("${OPTARG}")
        ;;
      x)
        X_ARGS=("${OPTARG}")
        print_header "Run ${X_ARGS} function"
        ;;
      \?)
        error "Invalid Option\n\n"
        display_help
        ;;
    esac
  done

  shift $((OPTIND-1))

  if [[ -z "${S_ARGS}" && -z "${X_ARGS}" ]]; then
    error "Missing Options\n\n"
    display_help
    exit 0
  fi

  if [[ -n "${S_ARGS}" && -n "${X_ARGS}" ]]; then
    error " Option -s and -x are mutually exclusive. You can only specify one at a time.\n\n"
    display_help
    exit 0
  fi

  if [[ -n "${S_ARGS}" ]]; then
    case "${S_ARGS}" in
      core)
        LOG=$(print_header "Setup basic configuration")
        update_system && install_library && \
        install_lazygit && install_ohmyposh && cleanup && \
        clear_screen && exit 0
        ;;
      mariadb)
        local vars=("MARIADB_VERSION")
        LOG=$(print_header "Setup MariaDB server")
        check_variables "${vars[@]}" && \
        update_system && install_library && \
        install_mariadb_server && \
        clear_screen && exit 0
        ;;
      dev)
        local vars=("GIT_VERSION" "NODE_VERSION" "PYTHON_VERSION" "MARIADB_VERSION")
        LOG=$(print_header "Setup Frappe Development server")
        check_variables "${vars[@]}" && \
        update_system && install_library && \
        install_git && install_nvm && install_python && \
        install_redis && install_mariadb_server && \
        clear_screen && exit 0
        ;;
      aio)
        LOG=$(print_header "Setup Frappe All-in-one server")
        clear_screen && exit 0
        ;;
      app)
        LOG=$(print_header "Setup Frappe App server")
        clear_screen && exit 0
        ;;
    esac
  fi
}

source scripts/utils.sh
source scripts/build-tools.sh
source scripts/core.sh
source scripts/db.sh
main "$@"
