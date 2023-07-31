#!/usr/bin/env bash

set -e

install_ohmyposh() {
  clear_screen

  if [ -z "$OMP_THEME" ]; then
    error "Variable OMP_THEME is not defined\n"
    exit 2
  fi

  print_header "Install oh-my-posh over zsh"

  sudo su -c "
    apt update &&
    apt upgrade -y && 
    apt install --no-install-recommends -y zsh &&
    apt autoclean -y"

  sudo su -c "curl https://ohmyposh.dev/install.sh | bash -s"

  mkdir -p $HOME/.oh-my-posh &&
    wget https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/${OMP_THEME}.omp.json -O $HOME/.oh-my-posh/default.omp.json

  if ! grep -q "export NVM_DIR" ~/.zshrc; then  
    printf "\n%s" \
      "eval \"\$(oh-my-posh init zsh --config ~/.oh-my-posh/default.omp.json)\"" |
      tee -a $HOME/.zshrc >/dev/null
      chsh -s $(which zsh)
  fi
}

change_theme() {

  clear_screen
  print_header "Change oh-my-posh theme"

  read -p "Please enter theme name: " -e -i "${OMP_THEME}" OMP_THEME

  wget https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/${OMP_THEME}.omp.json -O $HOME/.oh-my-posh/default.omp.json
}
