#!/usr/bin/env bash

set -e

load_menu() {

  while true;
  do
    clear_screen
    print_header "Welcome to setup script"

    printf "1) Setup server\n"
    printf "2) Prepare dev server\n"
    printf "3) Prepare frappe AIO server\n"
    printf "4) Prepare MariaDB server\n"
    printf "5) Prepare frappe APP server\n"
    printf "6) Create frappe instance & default site\n"
    printf "7) Add site to existing frappe instance\n"
    printf "8) Get & install custom app\n"
    printf "9) Enable production\n"
    
    printf "Q) Quit\n\n"

    read -p "Choose an option: " option
    clear_screen

    case $option in
      1) 
        config && install_library && install_ohmyposh
        ;;
      2)
        install_git && install_nvm && install_python &&
        install_bun && install_deno && install_go
        ;;
      3)
        install_git && install_nvm && install_python &&
        install_redis && install_mariadb_server
        ;;
      4)
        install_mariadb_server
        ;;
      5)
        install_git && install_nvm && install_python &&
        install_redis && install_mariadb_client
        ;;
      6)
        install_bench && create_instance && create_site
        ;;
      7)
        create_site
        ;;
      8)
        install_app
        ;;
      9)
        enable_prod
        ;;
      q|Q)
        exit
        ;;
      *) 
        error "Invalid option"
        ;;
    esac
  done

}
