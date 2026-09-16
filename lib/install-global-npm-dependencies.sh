#!/bin/bash

# shellcheck source=utils/install.sh
source utils/install.sh

# shellcheck source=utils/print.sh
source utils/print.sh ''

# shellcheck source=utils/prompt.sh
source utils/prompt.sh

##
# Installs global NPM dependencies.
# https://www.npmjs.com/
##
install_global_npm_dependencies() {
  print_info_title "Install global npm dependencies"
  print_gap

  local USER_CHOICE
  USER_CHOICE=$(confirm "Confirm installation")

  case $USER_CHOICE in
  y | Y)
    print_installed_global_npm_dependencies

    declare -A GLOBAL_NPM_DEPENDENCIES=(
      ["@compodoc/compodoc"]="@compodoc/compodoc"
      ["nx"]="nx"
      ["asar"]="asar"
      ["@bazel/bazelisk"]="@bazel/bazelisk"
      ["commitizen"]="commitizen"
      ["corepack"]="corepack"
      ["cz-conventional-changelog"]="cz-conventional-changelog"
      ["firebase-tools"]="firebase-tools"
      ["madge"]="madge"
      ["npm-check-updates"]="npm-check-updates"
      ["svgo"]="svgo"
      ["typescript"]="typescript"
      ["yarn"]="yarn"
    )

    for GLOBAL_NPM_DEPENDENCY in "${!GLOBAL_NPM_DEPENDENCIES[@]}"; do
      print_info_message "Installing global npm dependency $GLOBAL_NPM_DEPENDENCY..."
      print_gap

      install_global_npm_dependency "$GLOBAL_NPM_DEPENDENCY"
    done
    ;;
  n | N)
    print_warning_message "Canceled by user. User choice: ${USER_CHOICE}"
    ;;
  *)
    print_warning_message "Canceled by user. User choice: ${USER_CHOICE}"
    ;;
  esac
}
