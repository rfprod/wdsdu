#!/bin/bash

# shellcheck source=utils/install.sh
source utils/install.sh

# shellcheck source=utils/print.sh
source utils/print.sh ''

# shellcheck source=utils/prompt.sh
source utils/prompt.sh

##
# Installs Minikube.
# https://minikube.sigs.k8s.io/docs/
##
install_minikube() {
  print_info_title "Install minikube"
  print_gap

  local USER_CHOICE
  USER_CHOICE=$(confirm "Confirm installation")

  case $USER_CHOICE in
  y | Y)
    MINIKUBE_EXISTS=$(is_deb_installed minikube)
    if [ -z "${MINIKUBE_EXISTS}" ]; then
      print_info_message "The package is not installed. Installing the package..."
      print_gap

      # use a subshell to download curl to the ~/Downloads directory
      (cd ~/Downloads && curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb)
      sudo dpkg -i ~/Downloads/minikube_latest_amd64.deb

      print_info_message "Setting up minikube bash completion..."
      print_gap

      echo "source <(minikube completion bash)" >>~/.bashrc
    else
      print_success_message "The package is already installed."
      print_name_and_value "MINIKUBE_EXISTS" "${MINIKUBE_EXISTS}"
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
