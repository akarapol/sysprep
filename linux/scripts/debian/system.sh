#!/usr/bin/env bash

set -e

update_system() {
  clear_screen
  print_header "System update"

  sudo su -c "
    apt update &&
    apt upgrade -y &&
    apt autoclean -y"
}

install_library() {
  clear_screen
  print_header "Install library"

  sudo su -c "
    apt update &&
    apt upgrade -y &&
    apt install --no-install-recommends -y \
      build-essential software-properties-common ca-certificates \
      curl wget llvm make gpg openssl sudo unzip zsh \
      libffi-dev libnss3 libnspr4 tk-dev xvfb \
      libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev &&
    apt autoclean -y"
}

config() {
  printf "\n%s\n%s" \
    "unset HISTFILE" \
    "export PATH=~/.local/bin:/usr/local/bin:\$PATH" |
    tee -a ${HOME}/.zshrc >/dev/null
}

install_redis() {
  clear_screen
  print_header "Install redis server"

  sudo su -c "
    apt update &&
    apt upgrade -y &&
    apt install --no-install-recommends -y \
      redis-server &&
    apt autoclean -y"
}
