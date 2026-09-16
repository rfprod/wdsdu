#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

# shellcheck source=utils/error-handler.sh
source "$SCRIPT_DIR"/utils/error-handler.sh

install_error_handler

# shellcheck source=lib/pre-flight.sh
source "$SCRIPT_DIR"/lib/pre-flight.sh

# shellcheck source=utils/colors.sh
source "$SCRIPT_DIR"/utils/colors.sh ''

# shellcheck source=utils/print.sh
source "$SCRIPT_DIR"/utils/print.sh ''

# shellcheck source=utils/prompt.sh
source "$SCRIPT_DIR"/utils/prompt.sh

# shellcheck source=install-avd.sh
source "$SCRIPT_DIR"/install-avd.sh ''


# shellcheck source=utils/install.sh
source "$SCRIPT_DIR"/utils/install.sh

# shellcheck source=lib/install-google-chrome.sh
source "$SCRIPT_DIR"/lib/install-google-chrome.sh

# shellcheck source=lib/install-docker.sh
source "$SCRIPT_DIR"/lib/install-docker.sh

# shellcheck source=lib/install-minikube.sh
source "$SCRIPT_DIR"/lib/install-minikube.sh

# shellcheck source=lib/install-kubectl.sh
source "$SCRIPT_DIR"/lib/install-kubectl.sh

# shellcheck source=lib/install-helm.sh
source "$SCRIPT_DIR"/lib/install-helm.sh

# shellcheck source=lib/install-nodejs.sh
source "$SCRIPT_DIR"/lib/install-nodejs.sh

# shellcheck source=lib/install-global-npm-dependencies.sh
source "$SCRIPT_DIR"/lib/install-global-npm-dependencies.sh

# shellcheck source=lib/install-vscode.sh
source "$SCRIPT_DIR"/lib/install-vscode.sh

##
# Installs Flutter and AVD (Android SDK tools).
# https://flutter.dev/
# https://developer.android.com/studio#cmdline-tools
##
install_flutter_and_avd() {
  print_info_title "Install flutter + avd"
  print_gap

  local USER_CHOICE
  USER_CHOICE=$(confirm "Confirm installation")

  case $USER_CHOICE in
  y | Y)
    install_snap_package "flutter"
    install_avd
    ;;
  n | N)
    print_warning_message "Canceled by user. User choice: ${USER_CHOICE}"
    ;;
  *)
    print_warning_message "Canceled by user. User choice: ${USER_CHOICE}"
    ;;
  esac
}

##
# Installs system dependencies required for subsequent installations.
##
install_packages() {
  print_info_title "This script will install dependencies required for development"
  print_gap

  print_info_message "Updating apt"
  print_gap
  sudo apt update

  print_info_message "Installing dependencies required for subsequent installations..."
  print_gap

  install_package_via_manager "apt-transport-https" "apt"
  install_package_via_manager "ca-certificates" "apt"
  install_package_via_manager "software-properties-common" "apt"
  install_package_via_manager "bash-completion" "apt"
  install_package_via_manager "curl" "apt"
  install_package_via_manager "wget" "apt"
  install_package_via_manager "gnupg2" "apt"
  install_package_via_manager "unzip" "apt"

  print_info_message "Installing packages..."
  print_gap

  install_package_via_manager "guake" "apt"        # http://guake-project.org/index.html
  install_package_via_manager "tmux" "apt"         # https://en.wikipedia.org/wiki/Tmux
  install_package_via_manager "freerdp2-x11" "apt" # https://packages.debian.org/sid/freerdp2-x11
  install_package_via_manager "git" "apt"          # https://git-scm.com/
  install_package_via_manager "snapd" "apt"        # https://snapcraft.io/snapd
  install_package_via_manager "chromium" "snap"    # https://www.chromium.org/getting-involved/download-chromium/

  install_google_chrome

  install_docker

  install_minikube

  install_kubectl

  install_helm

  install_nodejs

  install_global_npm_dependencies

  install_vscode

  install_flutter_and_avd
}


install_packages
