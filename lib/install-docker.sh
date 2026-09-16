#!/bin/bash

# shellcheck source=utils/install.sh
source utils/install.sh

# shellcheck source=utils/print.sh
source utils/print.sh ''

# shellcheck source=utils/prompt.sh
source utils/prompt.sh

##
# Installs Docker.
# https://www.docker.com/
##
install_docker() {
  print_info_title "Install docker"
  print_gap

  local USER_CHOICE
  USER_CHOICE=$(confirm "Confirm installation")

  case $USER_CHOICE in
  y | Y)
    DOCKER_EXISTS=$(is_deb_installed docker-ce)
    if [ -z "${DOCKER_EXISTS}" ]; then
      print_info_message "The package is not installed. Installing the package..."
      print_gap

      sudo apt remove -y docker docker-engine docker.io

      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

      sudo apt update
      install_deb_package docker-ce

      print_info_message "Configuring docker to run without sudo..."
      print_gap

      # sudo groupadd docker
      # sudo usermod -aG docker "$USER"
      # newgrp docker
      # sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
      # sudo chmod g+rwx "$HOME/.docker" -R

      if ! getent group docker >/dev/null; then
        sudo groupadd docker
      fi

      if ! id -nG "$USER" | grep -qw docker; then
        sudo usermod -aG docker "$USER"
        print_info_message "Log out and back in for Docker group membership to take effect."
        sleep 5
      fi

    else
      print_success_message "The package is already installed."
      print_name_and_value "DOCKER_EXISTS" "${DOCKER_EXISTS}"
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
