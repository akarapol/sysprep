#!/usr/bin/env bash

set -e

install_ohmyposh() {
  clear_screen

  if [ -z $OMP_THEME ]; then
    error "Variable OMP_THEME not found\n"
    exit 1
  fi

  print_header "Install oh-my-posh over zsh"

  if [ -v ${OMP_THEME} ]; then
    error "Invalid parameter\n"
    exit 1
  fi

  sudo su -c "curl https://ohmyposh.dev/install.sh | bash -s"

  mkdir -p ~/.oh-my-posh &&
    wget https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/${OMP_THEME}.omp.json -O ~/.oh-my-posh/default.omp.json

  printf "\n%s" \
    "eval \"\$(oh-my-posh init zsh --config ~/.oh-my-posh/default.omp.json)\"" |
    tee -a ~/.zshrc >/dev/null
}

change_theme() {

  clear_screen
  print_header "Change oh-my-posh theme"

  read -p "Please enter theme name: " -e -i "${OMP_THEME}" OMP_THEME

  wget https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/${OMP_THEME}.omp.json -O ~/.oh-my-posh/default.omp.json
}
