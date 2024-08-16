#!/usr/bin/env bash
set -eu

# ************************************************************ #
# Setup OS                                                     #
# ************************************************************ #
update_system() {
  clear_screen
  print_header "System Update"

  sudo sh -c "
    apt update && apt upgrade -y &&
    apt autoclean -y && apt autoremove -y"
  LOG+=$(success "System update successfull")
}

cleanup() {
  clear_screen
  print_header "Cleanup"
  sudo sh -c "
    apt-get autoclean -y && apt-get autoremove -y &&
    rm -rf  /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*"
  LOG+=$(success "Cleanup cache and temp files successfull")
}

install_library() {
  clear_screen
  print_header "Install libraries"

  sudo sh -c "
    apt update && apt upgrade -y && \
    apt install --no-install-recommends -y \
      build-essential software-properties-common ca-certificates \
      curl wget llvm make gpg openssl sudo unzip zsh \
      libffi-dev libnss3 libnspr4 tk-dev xvfb \
      libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev && \
    apt autoclean -y && apt autoremove -y"
  LOG+=$(success "Install libraries successful")
}

# ************************************************************ #
# ADMIN TOOLS                                                  #
# ************************************************************ #

install_lazygit() {
  clear_screen
  print_header "Install LazyGit"

  if exist lazygit; then
    LOG+=$(success "LazyGIT already installed")
  else
    local version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    sudo sh -c "
      cd /tmp
      curl -Lo lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_x86_64.tar.gz
      tar xf lazygit.tar.gz lazygit
	  sudo install lazygit /usr/local/bin
	  rm lazygit.tar.gz lazygit"
    LOG+=$(success "Install LazyGIT successful")
  fi
}

install_ohmyposh() {
  clear_screen
  print_header "Install Oh My Posh over zsh"

  if exist oh-my-posh; then
    LOG+=$(success "Oh My Posh already installed")
  else
    sudo sh -c "
      apt update &&
      apt upgrade -y &&
      apt install --no-install-recommends -y zsh &&
      apt autoclean -y"
    sudo sh -c "curl https://ohmyposh.dev/install.sh | bash -s"
    local theme="catppuccin_frappe"
    mkdir -p $HOME/.oh-my-posh &&
      wget https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/${theme}.omp.json -O $HOME/.oh-my-posh/default.omp.json

    if ! grep -iq "oh-my-posh init zsh" ~/.zshrc; then
      printf "\n%s" \
        "eval \"\$(oh-my-posh init zsh --config ~/.oh-my-posh/default.omp.json)\"" |
        tee -a $HOME/.zshrc >/dev/null
        chsh -s $(which zsh)
    fi
    LOG+=$(success "Install Oh My Posh successful")
  fi
}
