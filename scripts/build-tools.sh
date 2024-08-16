#!/usr/bin/env bash
set -eu

# ************************************************************ #
# BUILD TOOLS                                                    #
# ************************************************************ #
install_git() {
  clear_screen
  print_header "Install GIT Version ${GIT_VERSION}"

  if exist git; then
    local git_version=$(git --version 2>&1 | awk '{print $3}')
    LOG+=$(success "GIT version ${git_version} already installed")
  else
    sudo sh -c "
      cd /tmp
      curl -fsSL https://github.com/git/git/archive/refs/tags/v${GIT_VERSION}.zip -o git.zip &&
      unzip git.zip &&
      cd git-${GIT_VERSION} &&
      make clean &&
      make prefix=/usr/local all &&
      make prefix=/usr/local install &&
      rm git.zip &&
      rm -rf git-${GIT_VERSION}"

    LOG+=$(success "Install GIT version ${GIT_VERSION} successful")
  fi
}

install_nvm() {
  clear_screen
  print_header "Install NVM"

  if [ -d "${HOME}/.nvm" ]; then
    local node_version=$(node --version)
    LOG+=$(success "NVM and node version ${node_version} already installed")
  else
    sh -c "curl -fsSL https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash"

    if ! grep -iq "export NVM_DIR" ~/.zshrc; then
      printf "\n%s\n%s\n%s" \
        "export NVM_DIR=\"\$HOME/.nvm\"" \
        "[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"  # This loads nvm" \
        "[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion" |
        tee -a ~/.zshrc ~/.bashrc >/dev/null
    fi
    LOG+=$(success "Install NVM successful")

    #temporary export NVM_DIR to install node, npm and yarn
    export NVM_DIR="${HOME}/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

    nvm install v${NODE_VERSION} &&
    nvm install-latest-npm &&
    npm install -g yarn

    LOG+=$(success "Install node, npm and yarn successful")
  fi
}

install_python() {
  clear_screen
  print_header "Install PYTHON Version ${PYTHON_VERSION}"

  if exist python; then
    local python_version=$(python --version 2>&1 | awk '{print $2}')
    LOG+=$(success "Python version ${python_version} already installed")
  else
    sudo sh -c "
      apt update && apt upgrade -y &&
      apt install --no-install-recommends -y \
        curl gcc libbz2-dev libev-dev libffi-dev \
        libgdbm-dev liblzma-dev libncurses-dev \
        libreadline-dev libsqlite3-dev libssl-dev \
        make tk-dev wget zlib1g-dev &&
      apt autoclean -y && apt autoremove -y"

    sudo sh -c "
      cd /tmp
      curl "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-${PYTHON_VERSION}.tar.xz" -o python.tar.xz
      mkdir -p /usr/src/python &&
      tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz &&
      rm -f python.tar.xz"

    sudo sh -c "
      cd /usr/src/python && ./configure &&
	    make clean && make -j '$(nproc)' && make install &&
      rm -rf /usr/src/python"

    find /usr/local -type d | grep -E "('test'|'tests'|'idle_test')" | xargs sudo rm -rf
    find /usr/local -type f | grep -E "('*.pyc'|'*.pyo'|'*.a')" | xargs sudo rm -f

    # create symlink
    cd /usr/local/bin

    sudo sh -c "
      ln -s idle3 idle &&
      ln -s pydoc3 pydoc &&
      ln -s python3 python &&
      ln -s python3-config python-config &&
      ln -s pip3 pip"

    python -m pip install --upgrade pip
    python -m pip install --upgrade setuptools

    sudo sh -c "python -m pip install poetry &&
      poetry config virtualenvs.in-project true"

    LOG+=$(success "Install PYTHON successful")
  fi
}
