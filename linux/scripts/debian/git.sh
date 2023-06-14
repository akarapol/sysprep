#!/usr/bin/env bash

set -e

install_git() {
  clear_screen
  
  if [ -z "$GIT_VERSION" ]; then
    error "Variable GIT_VERSION is not defined\n"
    exit 2
  fi

  print_header "Install Git ${GIT_VERSION}"

  if ! exists git; then
    sudo su -c "
      curl -fsSL https://github.com/git/git/archive/refs/tags/v${GIT_VERSION}.zip -o git.zip &&
      unzip git.zip &&
      cd git-${GIT_VERSION} &&
      make clean &&
      make prefix=/usr/local all &&
      make prefix=/usr/local install"

    sudo rm git.zip
    sudo rm -rf git-${GIT_VERSION}

    # smoke test
    git --version
  fi
}
