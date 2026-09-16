#!/bin/bash

# shellcheck source=utils/install.sh
source utils/install.sh

# shellcheck source=utils/print.sh
source utils/print.sh ''

# shellcheck source=utils/prompt.sh
source utils/prompt.sh

##
# Installs Helm.
# https://helm.sh/
##
install_helm() {
  print_info_title "Install helm"
  print_gap

  local USER_CHOICE
  USER_CHOICE=$(confirm "Confirm installation")

  case $USER_CHOICE in
  y | Y)
    install_snap_package "helm"
    HELM_COMPLETION_INSTALLED=$(find ~/.bashrc -print0 | xargs -0 grep "source <(helm completion bash)" --color=always)
    if [ -z "${HELM_COMPLETION_INSTALLED}" ]; then
      print_info_message "Helm bash completion is not configured. Setting up..."
      print_gap

      echo "source <(helm completion bash)" >>~/.bashrc
    else
      print_success_message "Helm bash completion is already configured."
      print_name_and_value "HELM_COMPLETION_INSTALLED" "${HELM_COMPLETION_INSTALLED}"
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
