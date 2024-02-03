#!/usr/bin/env bash

set -e

setup_repository() {
  if [ -z "$MARIADB_VERSION" ]; then
    error "Variable MARIADB_VERSION is not defined\n"
    exit 2
  fi
  
  print_header "Setup MariaDB repository"
  
  if ! exists mariadb; then
    sudo su -c "curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup && \
            bash mariadb_repo_setup --mariadb-server-version=$MARIADB_VERSION && \
            rm -f mariadb_repo_setup"
    
    sudo su -c "wget http://ftp.us.debian.org/debian/pool/main/r/readline5/libreadline5_5.2+dfsg-3+b13_amd64.deb && \
            dpkg -i libreadline5_5.2+dfsg-3+b13_amd64.deb && \
            rm -f libreadline5_5.2+dfsg-3+b13_amd64.deb"
  fi
}

install_mariadb_server() {
  clear_screen
  
  print_header "Install MariaDB ${MARIADB_VERSION}"

    setup_repository
    sudo su -c "
      apt update &&
      apt upgrade -y &&
      apt install --no-install-recommends -y \
          mariadb-server mariadb-client &&
      apt autoclean -y"

    config_mariadb_server

    # smoke test
    mariadb --version
}

install_mariadb_client() {
  clear_screen
  
  print_header "Install MariaDB ${MARIADB_VERSION}"

    setup_repository
    sudo su -c "
      apt update &&
      apt upgrade -y &&
      apt install --no-install-recommends -y \
          mariadb-client &&
      apt autoclean -y"

    config_mariadb_client

    # smoke test
    mariadb --version
}

config_mariadb_server() {
  print_header "Config MariaDB"

  # Config /etc/mysql/my.cnf
  sudo su -c 'echo "
  [mysqld]
  bind-address = 0.0.0.0
  character-set-client-handshake = FALSE
  character-set-server = utf8mb4
  collation-server = utf8mb4_unicode_ci

  [mysql]
  default-character-set = utf8mb4
  " >> /etc/mysql/my.cnf'

  sudo service mariadb start  &&
  sudo mysql_secure_installation &&
  sudo service mariadb restart
}

config_mariadb_client() {
  sudo su -c 'echo "
  [mysql]
  default-character-set = utf8mb4
  " >> /etc/mysql/my.cnf'  
}
