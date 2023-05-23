#!/usr/bin/env bash

set -e

install_git() {
  clear_screen
  print_header "Install Git ${GIT_VERSION}"

  if ! exists git; then
    sudo su -c "
      curl -fsSL https://github.com/git/git/archive/refs/tags/v${GIT_VERSION}.zip -o git.zip &&
      unzip git.zip &&
      cd git-${GIT_VERSION} &&
      make clean &&
      make prefix=/usr/local all &&
      make prefix=/usr/local install"

    rm git.zip
    rm -rf git-${GIT_VERSION}

    # smoke test
    git --version
  fi
}
