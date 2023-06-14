#!/usr/bin/env bash

set -e

install_nvm() {
  clear_screen
  
  if [ -z "$NODE_VERSION" ]; then
    error "Variable NODE_VERSION is not defined\n"
    exit 2
  fi  
  
  print_header "Install nvm"

  if ! [ -d "${HOME}/.nvm" ]; then
    curl -s https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash -s

    print_header "Install node ${NODE_VERSION}"

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

    nvm install ${NODE_VERSION} &&
      nvm install-latest-npm &&
      npm install -g yarn

    # smoke test
    node --version
    npm --version
    yarn --version

    printf "\n%s\n%s\n%s" \
      "export NVM_DIR='$HOME/.nvm'" \
      "[ -s '$NVM_DIR/nvm.sh' ] && \. '$NVM_DIR/nvm.sh'  # This loads nvm" \
      "[ -s '$NVM_DIR/bash_completion' ] && \. '$NVM_DIR/bash_completion'  # This loads nvm bash_completion" |
      tee -a ~/.zshrc >/dev/null

  fi
}
