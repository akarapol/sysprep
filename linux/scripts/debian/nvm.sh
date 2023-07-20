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
    curl -fsSL https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

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

    printf "\n%s\n%s\n%s\n" \
      "export NVM_DIR=\"\$HOME/.nvm\"" \
      "[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"  # This loads nvm" \
      "[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion" |
      tee -a ~/.zshrc >/dev/null
  fi
}

install_deno() {
  clear_screen

  print_header "Install deno"

  if ! [ -d "${HOME}/.deno" ]; then

    export DENO_DIR="$HOME/.deno"
    export PATH="$DENO_DIR/bin:$PATH"

    curl -fsSL https://deno.land/x/install/install.sh | bash

    printf "\n%s\n%s\n" \
      "export DENO_DIR=\"\$HOME/.deno\"" \
      "export PATH=\"\$DENO_DIR/bin:\$PATH\"" |
      tee -a ~/.zshrc ~/.bashrc >/dev/null

    #smoke test
    deno --version
  fi
}

install_bun() {
  clear_screen

  print_header "Install bun"

  if ! [ -d "${HOME}/.bun" ]; then
    
    export BUN_DIR="$HOME/.bun"
    export PATH="$BUN_DIR/bin:$PATH"

    curl -fsSL https://bun.sh/install | bash

    printf "\n%s\n%s\n" \
      "export BUN_DIR=\"\$HOME/.bun\"" \
      "export PATH=\"\$BUN_DIR/bin:\$PATH\"" |
      tee -a ~/.zshrc ~/.bashrc >/dev/null

    #smoke test
    bun --version
  fi
}