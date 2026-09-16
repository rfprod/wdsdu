#!/bin/bash

# shellcheck source=utils/install.sh
source utils/install.sh

# shellcheck source=utils/print.sh
source utils/print.sh ''

# shellcheck source=utils/prompt.sh
source utils/prompt.sh

##
# Installs Kubectl.
# https://kubernetes.io/docs/reference/kubectl/kubectl/
##
install_kubectl() {
  print_info_title "Install kubectl"
  print_gap

  local USER_CHOICE
  USER_CHOICE=$(confirm "Confirm installation")

  case $USER_CHOICE in
  y | Y)
    KUBECTL_EXISTS=$(is_deb_installed kubectl)
    if [ -z "${KUBECTL_EXISTS}" ]; then
      print_info_message "The package is not installed. Installing the package..."
      print_gap

      local K8S_MINOR
      K8S_MINOR="${K8S_MINOR:-v1.37}"
      local KEYRING
      KEYRING="/etc/apt/keyrings/kubernetes-apt-keyring.gpg"
      local LIST
      LIST="/etc/apt/sources.list.d/kubernetes.list"

      sudo install -d -m 0755 /etc/apt/keyrings

      curl -fsSL \
          "https://pkgs.k8s.io/core:/stable:/${K8S_MINOR}/deb/Release.key" |
          sudo gpg --dearmor --yes -o "$KEYRING"

      sudo chmod 0644 "$KEYRING"

      printf 'deb [signed-by=%s] https://pkgs.k8s.io/core:/stable:/%s/deb/ /\n' \
          "$KEYRING" "$K8S_MINOR" |
          sudo tee "$LIST" >/dev/null

      sudo apt-get update
      install_deb_package kubectl

      print_info_message "Setting up kubectl bash completion..."
      print_gap

      echo "source <(kubectl completion bash)" >>~/.bashrc
    else
      print_success_message "The package is already installed."
      print_name_and_value "KUBECTL_EXISTS" "${KUBECTL_EXISTS}"
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
