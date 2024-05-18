#!/usr/bin/env bash

set -e

install_kitty() {
  curl -s https://sw.kovidgoyal.net/kitty/installer.sh | sh -s
  ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
  ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/
  
  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
  sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
	sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
}

install_nvchad() {
  # Install neovim 
  sudo rm -rf /opt/nvim

  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz 
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
    
  rm -rf nvim-linux64.tar.gz
	ln -sf /opt/nvim-linux64/bin/nvim ~/.local/bin/
  
  # Install nvchad starter
  rm -rf $HOME/.local/share/nvim
  rm -rf $HOME/.config/nvim
  git clone https://github.com/nvchad/starter $HOME/.config/nvim
}


