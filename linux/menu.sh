#!/usr/bin/env bash

set -e

load_menu() {

  while true;
  do
    clear_screen
    print_header "Welcome to setup script"

    printf "1) Setup server\n"
    printf "2) Setup database\n"
    printf "3) Setup frappe\n"
    printf "4) Install app\n"

    printf "Q) Quit\n\n"

    read -p "Choose an option: " option
    clear_screen

    case $option in
      1) 
        install_library && config &&
        install_git && install_nvm && install_python &&
        install_ohmyposh
        ;;
      2)
        install_redis && install_mariadb
        ;;
      3)
        install_bench && create_instance
        ;;
      4)
        install_app
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