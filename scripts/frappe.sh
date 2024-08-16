#!/usr/bin/env bash
set -eu

# ************************************************************ #
# FRAPPE                                                       #
# ************************************************************ #
install_bench() {
  clear_screen
  print_header "Install Bench Version ${BENCH_VERSION}"

  if exist bench; then
    LOG+=$(success "Frappe Bench already installed")
  else
    # frappe needed library
    sudo sh -c "
      apt update && apt upgrade -y &&
      apt install --no-install-recommends -y \
          xvfb libfontconfig wkhtmltopdf &&
      apt autoclean -y && apt autoremove -y"

    # additional library
    sudo sh -c "
      apt install --no-install-recommends -y \
        libzbar0
      apt autoclean -y && apt autoremove -y"

    pip install frappe-bench=="${BENCH_VERSION}"
    sudo pip install frappe-bench=="${BENCH_VERSION}"

	LOG+=$(success "Install Bench successful")
  fi
}

setup_repo() {
  if [ -f ${REPO_SSH_KEY} ]; then
    if ! grep -iq "Host frappe-repo" ~/.ssh/config; then
      printf "\n%s\n%s\n%s\n%s\n%s\n" \
        "HOST frappe-repo" \
        " HostName ${REPO_URI}" \
        " Port ${REPO_PORT}" \
        " User git" \
        " IdentityFile ${REPO_SSH_KEY}" |
        tee -a ~/.ssh/config >/dev/null
    fi
    REPO_ADDR=ssh://frappe-repo/frappe
  else
    LOG+=$(error "SSH key ${REPO_SSH_KEY} is missing")
    exit 1
  fi
  LOG+=$(success "Setup Frappe repository")
}

create_instance() {
  clear_screen
  print_header "Create new instance ${INSTANCE} in ${INSTALL_DIR}"

  bench init "${INSTALL_DIR}/${INSTANCE}" \
              --frappe-branch "${FRAPPE_VERSION}" \
              --frappe-path "${REPO_ADDR}/frappe" \
              --verbose &&
  cd "${INSTALL_DIR}/${INSTANCE}" &&
  chmod -R o+rx "${INSTALL_DIR}/${INSTANCE}"
  LOG+=$(success "Create instance ${INSTANCE} in ${INSTALL_DIR}")
}

create_site() {
  clear_screen
  print_header "Setup site >> ${SITE_NAME}"

  if [ -d "${INSTALL_DIR}/${INSTANCE}/${SITE_NAME}" ]; then
	  LOG+=$(success "Site ${SITE_NAME} already exist")
  else
    print_header "Please provide the admin user and password of DB server"
    while true;
    do
      read -p "User: " user;
      if [ -n "$user" ]; then break;  fi
    done
    set_password
    local db_pass=$PASSWD
    PASSWD=

    print_header "Please provide the administrator password for site ${SITE_NAME}"
    set_password
    local admin_pass=$PASSWD
    PASSWD=

	  cd "${INSTALL_DIR}/${INSTANCE}" &&
    bench new-site "${SITE_NAME}" \
         --no-mariadb-socket \
         --db-host "${DB_HOST}" \
         --db-root-username "$user" \
         --db-root-password "${db_pass}" \
         --db-name "${SITE_DB_NAME}" \
         --admin-password "${admin_pass}" \
         --verbose &&
	  bench --site "${SITE_NAME}" add-to-hosts
	  LOG+=$(success "Create site ${SITE_NAME} for instance ${INSTANCE}")
  fi
}

install_app() {
  setup_repo
  cd "${INSTALL_DIR}/${INSTANCE}"

  for app in ${APP_LIST}; do
    local app_name="${app%%=*}"  # Extract key (everything before =)
    local app_branch="${app#*=}"  # Extract value (everything after =)

    bench get-app "{app_name}" "${REPO_ADDR}/${app_name}" --branch ${app_branch} &&
    bench --site "${SITE_NAME}" install-app "${app_name}"
    LOG+=$(success "Install app ${app_name} branch ${app_branch}")
  done
}

enable_dev() {
  cd "${INSTALL_DIR}/${INSTANCE}"
  bench set-config -g developer_mode true
  LOG+=$(success "Setup Development Mode")
}

setup_frappe() {
  clear_screen
  print_header "Install Frappe Version ${FRAPPE_VERSION}"

  setup_repo && create_instance && \
  create_site && install_app
  LOG+=$(success "Install Frappe successful")
}
