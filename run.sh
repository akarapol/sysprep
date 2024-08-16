#!/usr/bin/env bash
set -eu

RUNNING_DIR=$(dirname -- "${0}")
S_ARGS=
X_ARGS=

source scripts/utils.sh

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
        print_header "Setup basic configuration"
        ;;
      mariadb)
        print_header "Setup MariaDB server"
        ;;
      dev)
        print_header "Setup Frappe Development server"
        ;;
      aio)
        print_header "Setup Frappe All-in-one server"
        ;;
      app)
        print_header "Setup Frappe App server"
        ;;
    esac
  fi
}

main "$@"
