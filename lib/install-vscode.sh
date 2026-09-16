#!/bin/bash

# shellcheck source=utils/install.sh
source utils/install.sh

# shellcheck source=utils/print.sh
source utils/print.sh ''

# shellcheck source=utils/prompt.sh
source utils/prompt.sh

##
# Installs VSCode.
# https://code.visualstudio.com/
##
install_vscode() {
  print_info_title "Install vscode"
  print_gap

  local USER_CHOICE
  USER_CHOICE=$(confirm "Confirm installation")

  case $USER_CHOICE in
  y | Y)
    VSCODE_EXTENSION_EXISTS=$(is_deb_installed code)
    if [ -z "${VSCODE_EXTENSION_EXISTS}" ]; then
      print_info_message "The package is not installed. Installing the package..."
      print_gap

      wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
      sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
      sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
      rm -f packages.microsoft.gpg
      sudo apt update
      install_deb_package code

      declare -A VSCODE_EXTENSIONS=(
        ["rust-lang.rust-analyzer"]="rust-lang.rust-analyzer"
        ["atishay-jain.all-autocomplete"]="atishay-jain.all-autocomplete"
        ["johnpapa.angular-essentials"]="johnpapa.angular-essentials"
        ["Angular.ng-template"]="Angular.ng-template"
        ["johnpapa.Angular2"]="johnpapa.Angular2"
        ["natewallace.angular2-inline"]="natewallace.angular2-inline"
        ["jasonnutter.vscode-codeowners"]="jasonnutter.vscode-codeowners"
        ["ms-azuretools.vscode-containers"]="ms-azuretools.vscode-containers"
        ["dart-code.dart-code"]="dart-code.dart-code"
        ["ms-azuretools.vscode-docker"]="ms-azuretools.vscode-docker"
        ["mikestead.dotenv"]="mikestead.dotenv"
        ["editorconfig.editorconfig"]="editorconfig.editorconfig"
        ["dbaeumer.vscode-eslint"]="dbaeumer.vscode-eslint"
        ["dart-code.flutter"]="dart-code.flutter"
        ["github.vscode-github-actions"]="github.vscode-github-actions"
        ["tomoyukim.vscode-mermaid-editor"]="tomoyukim.vscode-mermaid-editor"
        ["christian-kohler.path-intellisense"]="christian-kohler.path-intellisense"
        ["esbenp.prettier-vscode"]="esbenp.prettier-vscode"
        ["hashicorp.terraform"]="hashicorp.terraform"
        ["foxundermoon.shell-format"]="foxundermoon.shell-format"
        ["timonwong.shellcheck"]="timonwong.shellcheck"
        ["stylelint.vscode-stylelint"]="stylelint.vscode-stylelint"
        ["ghaschel.vscode-angular-html"]="ghaschel.vscode-angular-html"
        ["sadesyllas.vscode-workspace-switcher"]="sadesyllas.vscode-workspace-switcher"
        ["redhat.vscode-yaml"]="redhat.vscode-yaml"
      )

      print_info_message "Installing the vscode extensions..."
      print_gap

      for VSCODE_EXTENSION in "${!VSCODE_EXTENSIONS[@]}"; do
        code --install-extension "$VSCODE_EXTENSION"
      done

    else
      print_success_message "The package is already installed."
      print_name_and_value "VSCODE_EXTENSION_EXISTS" "${VSCODE_EXTENSION_EXISTS}"
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
