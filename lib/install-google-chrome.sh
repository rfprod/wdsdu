#!/bin/bash

# shellcheck source=utils/install.sh
source utils/install.sh

# shellcheck source=utils/print.sh
source utils/print.sh ''

# shellcheck source=utils/prompt.sh
source utils/prompt.sh

##
# Installs Google Chrome.
# https://www.google.com/chrome/index.html
##
install_google_chrome() {
  print_info_title "Install google-chrome-stable"
  print_gap

  local USER_CHOICE
  USER_CHOICE=$(confirm "Confirm installation")

  case $USER_CHOICE in
  y | Y)
    CHROME_EXISTS=$(is_deb_installed google-chrome-stable)
    if [ -z "${CHROME_EXISTS}" ]; then
      print_info_message "The package is not installed. Installing the package..."
      print_gap

      local KEYRING
      KEYRING="/etc/apt/keyrings/google-chrome.gpg"

      sudo install -d -m 0755 /etc/apt/keyrings

      curl -fsSL https://dl.google.com/linux/linux_signing_key.pub |
          sudo gpg --dearmor --yes -o "$KEYRING"

      sudo chmod 0644 "$KEYRING"

      printf '%s\n' \
          'deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main' |
          sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null

      sudo apt update
      install_deb_package "google-chrome-stable"
    else
      print_success_message "The package is already installed."
      print_name_and_value "CHROME_EXISTS" "${CHROME_EXISTS}"
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
