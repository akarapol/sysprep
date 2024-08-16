#!/usr/bin/env bash
set -eu

# ************************************************************ #
# Redis                                                        #
# ************************************************************ #
install_redis() {
  clear_screen
  print_header "Install Redis Server"

  if exist redis-server; then
    LOG+=$(success "Redis already installed")
  else
    sudo sh -c "
      apt update && apt upgrade -y &&
      apt install --no-install-recommends -y \
        redis-server &&
      apt autoclean -y && apt autoremove -y"

	  LOG+=$(success "Install Redis successful")
  fi
}

# ************************************************************ #
# MariaDB                                                      #
# ************************************************************ #
setup_mariadb_repository() {
  LOG+=$(success "Setup MariaDB Repository")
  sudo sh -c "curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup \
    | bash -s -- --skip-maxscale --mariadb-server-version=\"mariadb-${MARIADB_VERSION}\""
}

install_mariadb_server() {
  clear_screen
  print_header "Install MariaDB Server"

  if exist mariadb; then
    LOG+=$(success "MariaDB Server already installed")
  else
    setup_mariadb_repository

    sudo sh -c "
      apt update && apt upgrade -y &&
      apt install --no-install-recommends -y \
          mariadb-server mariadb-client &&
      apt autoclean -y && apt autoremove -y"

    # Config /etc/mysql/my.cnf
    sudo sh -c 'echo "
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

    LOG+=$(success "Install MariaDB Server successful")
  fi
}

install_mariadb_client() {
  clear_screen
  print_header "Install MariaDB Client"

  if exist mariadb; then
    LOG+=$(success "MariaDB Client already installed")
  else
    setup_mariadb_repository

    sudo sh -c "
      apt update && apt upgrade -y &&
      apt install --no-install-recommends -y \
          mariadb-client &&
      apt autoclean -y && apt autoremove -y"

    # Config /etc/mysql/my.cnf
    sudo sh -c 'echo "
    [mysql]
    default-character-set = utf8mb4
    " >> /etc/mysql/my.cnf'

    LOG+=$(success "Install MariaDB Client successful")
  fi
}
