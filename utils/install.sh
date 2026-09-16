#!/bin/bash

# shellcheck source=utils/colors.sh
source utils/colors.sh ''

# shellcheck source=utils/print.sh
source utils/print.sh ''

# shellcheck source=utils/prompt.sh
source utils/prompt.sh

##
# Prints installed global npm packages.
##
print_installed_global_npm_dependencies() {
  local DEPS
  DEPS=$(sudo npm list -g --depth=0)
  print_success_title "Installed dependencies:"
  # shellcheck disable=SC2059
  printf "\n${DEPS}\n"
}

##
# Installs an npm package globally if it is not installed yet.
##
install_global_npm_dependency() {
  local DEPENDENCY_NAME
  DEPENDENCY_NAME=$1
  local DEPS
  DEPS=$(sudo npm list -g --depth=0)

  print_info_message "Checking if $DEPENDENCY_NAME is installed"
  print_gap

  if grep -q "${DEPENDENCY_NAME}"@ <<<"$DEPS"; then
    print_success_message "$DEPENDENCY_NAME is installed"
    print_gap
  else
    print_warning_message "$DEPENDENCY_NAME is not installed"
    print_gap

    sudo npm install -g "${DEPENDENCY_NAME}@latest"
  fi
}

##
# Checks if a deb package is installed.
##
is_deb_installed() {
  dpkg-query \
    -W \
    -f='${Status}' \
    "$1" 2>/dev/null |
    grep -q '^install ok installed$'
}

##
# Installs a deb package if it is not installed yet.
##
install_deb_package() {
  local PACKAGE_NAME
  PACKAGE_NAME="$1"

  print_info_message "Checking if $PACKAGE_NAME is installed"
  print_gap

  if is_deb_installed "$PACKAGE_NAME"; then
      print_success_title "$PACKAGE_NAME is already installed"
      return 0
  fi

  print_info_message "$PACKAGE_NAME is not installed. Installing the package..."
  print_gap

  sudo apt install -y "$1" || exit 15

  # this step is required if bash-completion was not installed prior to this script execution
  if [ "$1" = 'bash-completion' ]; then
    source /etc/bash_completion
  fi
}

##
# Installs a snap package if it is not installed yet.
##
install_snap_package() {
  local PACKAGE_NAME
  PACKAGE_NAME=$1

  local SNAP_EXISTS
  SNAP_EXISTS=$(snap find "$PACKAGE_NAME")

  if [ "${SNAP_EXISTS}" == "No matching snaps for ""${PACKAGE_NAME}""" ]; then
    print_info_message "$PACKAGE_NAME is not installed. Installing the package..."
    print_gap

    sudo snap install "$PACKAGE_NAME" --classic || exit 15
  else
    print_success_title "$PACKAGE_NAME is already installed"
    print_gap
  fi
}

##
# Installs a debian/snap package that does not require special installation instructions.
##
install_package_via_manager() {
  print_info_title "Install $1 via $2"
  print_gap

  local USER_CHOICE
  USER_CHOICE=$(confirm "Confirm installation")

  case $USER_CHOICE in
  y | Y)
    if [ "$2" == 'apt' ]; then
      install_deb_package "$1"
    elif [ "$2" == 'snap' ]; then
      install_snap_package "$1"
    else
      print_error_title "This package manager is not supported $2"
      exit 15
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
