#!/usr/bin/env bash

set -e

install_python() {
  clear_screen
  print_header "Install python ${PYTHON_VERSION}"

  sudo su -c "
    apt update &&
    apt upgrade -y && 
    apt install --no-install-recommends -y \
      libbz2-dev libncurses-dev libncursesw5-dev libgdbm-dev \
      liblzma-dev libsqlite3-dev libgdbm-compat-dev libreadline-dev &&
    apt autoclean -y"

  if ! exists python; then
    sudo su -c "
      curl "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-${PYTHON_VERSION}.tar.xz" -o python.tar.xz
      mkdir -p /usr/src/python &&
      tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz &&
      rm -f python.tar.xz"

    cd /usr/src/python

    sudo su -c "
      ./configure \
        --enable-optimizations \
        --enable-shared"

    sudo su -c "
      make clean &&
      make -j '$(nproc)' &&
      make install &&
      rm -rf /usr/src/python"

    find /usr/local -type d | grep -E "('test'|'tests'|'idle_test')" | xargs sudo rm -rf
    find /usr/local -type f | grep -E "('*.pyc'|'*.pyo'|'*.a')" | xargs sudo rm -f

    # create symlink
    sudo su -c "
      cd /usr/local/bin
      ln -s idle3 idle &&
      ln -s pydoc3 pydoc &&
      ln -s python3 python &&
      ln -s python3-config python-config"

    # smoke test
    python --version
  fi
}

upgrade_pip() {
  print_header "Upgrade pip"

  python -m pip install --upgrade pip
  python -m pip install --upgrade setuptools

  if ! exists pip; then
    cd /usr/local/bin
    sudo su -c "ln -s pip3 pip"
  fi

  # smoke test
  pip --version
}

install_poetry() {
  print_header "Install poetry"

  if ! exists poetry; then
    sudo pip install poetry &&
      poetry config virtualenvs.in-project true

    # smoke test
    poetry --version
  fi
}
