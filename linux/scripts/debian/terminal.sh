#!/usr/bin/env bash

set -e

install_kitty() {
  curl -s https://sw.kovidgoyal.net/kitty/installer.sh | sh -s
}

install_nvchad() {
  
  # Install neovim 
  sudo rm -rf /opt/nvim

  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz 
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
  
  rm -rf nvim-linux64.tar.gz

  # Install nvchad starter
  rm -rf $HOME/.local/share/nvim
  rm -rf $HOME/.config/nvim
  git clone https://github.com/nvchad/starter $HOME/.config/nvim
}


