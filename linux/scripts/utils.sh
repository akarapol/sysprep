#!/usr/bin/env bash

set -e

# Color variables
default="\033[0m"
black="\033[30m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
magenta="\033[35m"
cyan="\033[36m"
white="\033[37m"

error() {
  printf "${red}$1${default}"
}

warning() {
  printf "${yellow}$1${default}"
}

info() {
  printf "${cyan}$1${default}"
}

clear_screen() {
  printf "\033c"
  printf "\n"
}

print_header() {
  info $(printf -- "-%.0s" {1..55})
  info "\n${1}\n"
  info $(printf -- "-%.0s" {1..55})
  printf "\n\n"
}

print_line() {
  info $(printf -- "-%.0s" {1..55})
  printf "\n"
}

exists() {
  hash "$1" 2>/dev/null
}
