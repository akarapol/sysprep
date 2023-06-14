#!/usr/bin/env bash

set -e

install_mariadb() {
  clear_screen
  
  if [ -z "$MARIADB_VERSION" ]; then
    error "Variable MARIADB_VERSION is not defined\n"
    exit 2
  fi

  print_header "Install MariaDB ${MARIADB_VERSION}"

  if ! exists mariadb; then
    sudo su -c "curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup && \
            bash mariadb_repo_setup --os-type=debian  --os-version=buster --mariadb-server-version=$MARIADB_VERSION && \
            rm -f mariadb_repo_setup"
    
    sudo su -c "wget http://ftp.us.debian.org/debian/pool/main/r/readline5/libreadline5_5.2+dfsg-3+b13_amd64.deb && \
            dpkg -i libreadline5_5.2+dfsg-3+b13_amd64.deb && \
            rm -f libreadline5_5.2+dfsg-3+b13_amd64.deb"

    sudo su -c "
      apt update &&
      apt upgrade -y &&
      apt install --no-install-recommends -y \
          mariadb-server mariadb-client &&
      apt autoclean -y"

    # Config /etc/mysql/my.cnf
    sudo su -c 'echo "
    [mysqld]
    character-set-client-handshake = FALSE
    character-set-server = utf8mb4
    collation-server = utf8mb4_unicode_ci

    [mysql]
    default-character-set = utf8mb4
    " >> /etc/mysql/my.cnf'

    config_mariadb

    # smoke test
    mariadb --version
  fi
}

config_mariadb(){
  print_header "Config MariaDB"

  sudo service mariadb start  &&
  sudo mysql_secure_installation &&
  sudo service mariadb restart
}
