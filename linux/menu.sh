#!/usr/bin/env bash

set -e

load_menu() {

  while true;
  do
    clear_screen
    print_header "Welcome to setup script"

    printf "1) Setup server\n"
    printf "2) Install redis & mariadb\n"
    
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
      q|Q)
        exit
        ;;
      *) 
        error "Invalid option"
        ;;
    esac
  done

}