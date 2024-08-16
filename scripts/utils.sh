#!/usr/bin/env bash
set -eu

reset="\033[0m"
black="\033[30m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
magenta="\033[35m"
cyan="\033[36m"
white="\033[37m"

LOG=

clear_screen() {
  printf "\033c${LOG}${reset}\n"
}

print_header() {
    printf "${blue}%s\n%s\n%s${reset}\n" \
      $(printf -- "=%.0s" {1..72}) \
      " ${1}" \
      $(printf -- "=%.0s" {1..72})
}

info() {
  printf "\n\u2139 ${white}${1}${reset}"
}

warning() {
  printf "\n${yellow}${1}${reset}"
}

error() {
  printf "\n\u274C ${red}${1}${reset}"
}

success() {
  printf "\n\u2714 ${green}${1}${reset}"
}

exist() {
  hash "${1}" 2>/dev/null
}

check_variables() {
  local check_list=("$@")
  local fail=0
  local err_msg=$(print_header "Check Variables")

  for i in "${check_list[@]}"; do
    if [ -z "${!i}" ]; then
      err_msg+=$(error "Variable ${i} must be defined")
      fail=1
    fi
  done

  if [[ ${fail} == 1 ]]; then
    printf "\033c${err_msg}\n"
    exit 1
  fi
}
