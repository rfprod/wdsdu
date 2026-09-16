#!/bin/bash

# shellcheck source=utils/install.sh
source utils/install.sh

# shellcheck source=utils/print.sh
source utils/print.sh ''

# shellcheck source=utils/prompt.sh
source utils/prompt.sh

##
# Installs NodeJS.
# https://nodejs.org/en/
##
install_nodejs() {
  print_info_title "Install nodejs v16, and build-essential, and update npm to latest version"
  print_gap

  local USER_CHOICE
  USER_CHOICE=$(confirm "Confirm installation")

  case $USER_CHOICE in
  y | Y)
    NODE_EXISTS=$(is_deb_installed nodejs)
    if [ -z "${NODE_EXISTS}" ]; then
      print_info_message "The package is not installed. Installing the package..."
      print_gap

      NODE_MAJOR="${NODE_MAJOR:-24}"
      curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | sudo -E bash -

      install_deb_package nodejs
      install_deb_package build-essential
      sudo npm install -g npm
    else
      print_success_message "The package is already installed."
      print_name_and_value "NODE_EXISTS" "${NODE_EXISTS}"
      print_gap
    fi
    ;;
  n | N)
    print_warning_message "Canceled by user. User choice: ${USER_CHOICE}"
    ;;
  *)
    print_warning_message "Canceled by user. User choice: ${USER_CHOICE}"
    ;;
  esac
}
