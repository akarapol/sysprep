#!/usr/bin/env bash

set -e

if [ -z "$X_USER" ]; then
  error "Variable X_USER is not defined\n"
  exit 2
fi

if [ -z "$X_TOKEN" ]; then
  error "Variable X_TOKEN is not defined\n"
  exit 2
fi

if [ -z "$X_REPO" ]; then
  error "Variable X_REPO is not defined\n"
  exit 2
fi

REPO_URL=https://$X_USER:$X_TOKEN@$X_REPO
INSTANCE=

install_bench() {
  clear_screen

  if [ -z "$BENCH_VERSION" ]; then
    error "Variable BENCH_VERSION is not defined\n"
    exit 2
  fi

  print_header "Install frappe-bench $BENCH_VERSION" 
  
  if ! exists bench; then
    # frappe needed library       
    sudo su -c "
      apt update &&
      apt upgrade -y &&      
      apt install --no-install-recommends -y \
          xvfb libfontconfig wkhtmltopdf &&
      apt autoclean -y"

    # playwright library
    sudo su -c "
      apt install --no-install-recommends -y \
          libatk1.0-0 libatk-bridge2.0-0 libcups2 libxkbcommon0 libxcomposite1 \
          libxrandr2 libgbm1 libpango-1.0-0 libcairo2 libasound2 libatspi2.0-0 &&
      apt autoclean -y"

    sudo pip install frappe-bench==$BENCH_VERSION

    # smoke test
    bench --version
  fi
}

confirm(){     
  while true;
  do
    read -p "Please type '$1' to confirm: " name
    
    if [ "$name" = "$1" ]; then
        break;
    fi
    error "Invalid!!!, Try again\n"
  done  
}

create_instance() {
  clear_screen
  
  if [ -z "$REPO_URL" ]; then
    error "Variable REPO_URL is not defined\n"
    exit 2
  fi

  if [ -z "$APP_DIR" ]; then
    error "Variable APP_DIR is not defined\n"
    exit 2
  fi

  if [ -z "$FRAPPE_VERSION" ]; then
    error "Variable FRAPPE_VERSION is not defined\n"
    exit 2
  fi

  if [ -z "$INSTANCE" ]; then
    error "Variable INSTANCE is not defined\n"
    
    while true;
    do
      print_header "Please specify instance name"
      read -p "Name: " INSTANCE;
      if [ -n "$INSTANCE" ]; then break; fi
    done
  fi

  clear_screen
  print_header "Create new instance \"$INSTANCE\" in \"$APP_DIR\""

  confirm $INSTANCE &&
  bench init $APP_DIR/$INSTANCE --frappe-branch $FRAPPE_VERSION --frappe-path $REPO_URL/frappe --verbose &&
  cd $APP_DIR/$INSTANCE &&
  chmod -R o+rx $APP_DIR/$INSTANCE
  bench find .

  create_site 
}

create_site() {
  clear_screen

  if [ -z "$INSTANCE" ]; then
    error "Variable INSTANCE is not defined\n"

    while true;
    do
      print_header "Please specify instance name"
      read -p "Name: " INSTANCE;
      if [ -n "$INSTANCE" ]; then break; fi
    done
  fi

  if [ -z "$ROOT_PASSWORD" ]; then
    error "Variable ROOT_PASSWORD is not defined\n"
    exit 2
  fi

  if [ -z "$ADMIN_PASSWORD" ]; then
    error "Variable ADMIN_PASSWORD is not defined\n"
    exit 2
  fi

  clear_screen
  while true;
  do
    print_header "Please specify parameters"
    read -p "Site: " site;
    read -p "Database name: " -e -i "$site" db_name;
    if [ -n "$site" ] && [ -n "$db_name" ]; then break; fi
  done

  clear_screen
  print_header "Setup site >> $site"
  info "Create new site for instance $APP_DIR/$INSTANCE\n"
  info "with site name $site\n\n"

  confirm $site &&
  cd $APP_DIR/$INSTANCE &&
  bench new-site $site --mariadb-root-password $ROOT_PASSWORD --admin-password $ADMIN_PASSWORD --db-name $db_name --verbose
  bench use $site &&
  bench set-config developer_mode True &&
  bench set-config disable_session_cache True &&
  bench set-config shallow_clone False
}

install_app() {
  clear_screen

  if [ -z "$INSTANCE" ]; then
    error "Variable INSTANCE is not defined\n"

    while true;
    do
      print_header "Please specify instance name"
      read -p "Name: " INSTANCE;
      if [ -n "$INSTANCE" ]; then break; fi
    done
  fi
  clear_screen
  if [ -z "$SITE" ]; then
    error "Variable SITE is not defined\n"

    while true;
    do
      print_header "Please specify site name"
      read -p "Site: " -e -i "$SITE" SITE;
      if [ -n "$SITE" ]; then break; fi
    done
  fi

  clear_screen
  print_header "Install app on $SITE"
  
  while true;
  do 
    read -p "App name: " APP; 
    if [ -n "$APP" ]; then break; fi    
  done      
      
  while true;
  do 
    read -p "Branch: " BRANCH;
    if [ -n "$BRANCH" ]; then break;  fi
  done

  clear_screen
  print_header "Install $APP($BRANCH) on $SITE"

  cd $APP_DIR/$INSTANCE
  confirm $SITE

  bench get-app $APP $REPO_URL/$APP --branch $BRANCH &&
  bench --site $SITE install-app $APP
}

enable_prod() {
  clear_screen

  if [ -z "$INSTANCE" ]; then
    error "Variable INSTANCE is not defined\n"

    while true;
    do
      print_header "Please specify instance name"
      read -p "Name: " INSTANCE;
      if [ -n "$INSTANCE" ]; then break; fi
    done
  fi

  while true;
  do
    print_header "Please specify site name"
    read -p "Site: " -e -i "$SITE" SITE;
    if [ -n "$SITE" ]; then break; fi
  done

  clear_screen
  print_header "Enable production on $SITE"

  warning "This task will enable production mode for $SITE\n"
  
  cd $APP_DIR/$INSTANCE
  confirm $SITE
  
  sudo su -c "
    apt update &&
    apt upgrade -y &&      
    apt install --no-install-recommends -y \
        supervisor &&
    apt autoclean -y"

  bench --site $SITE set-config developer_mode 0
  bench --site $SITE add-to-hosts
  bench --site $SITE enable-scheduler
  bench --site $SITE set-maintenance-mode off
  
  sudo su -c "
    yes | bench setup production $(whoami) &&
    service supervisor restart &&
    sed -i '6i chown="$(whoami)":"$(whoami)"' /etc/supervisor/supervisord.conf &&
    yes | bench setup production $(whoami) &&
    bench restart"
}