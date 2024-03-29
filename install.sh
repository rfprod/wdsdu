#!/bin/bash

source utils/colors.sh ''
source utils/print.sh ''
source install-avd.sh ''

USER_INPUT_TIMEOUT=6

set -o errtrace

trap '{ EXIT_CODE=$?; exit $EXIT_CODE; }' SIGTERM

##
# Sets the default user choice value.
##
defaultUserChoice() {
  if [ -z "$userChoice" ]; then
    userChoice=y
  fi
}

##
# Sets the user choice value to 'no', used for optional installations.
##
optionalUserChoice() {
  if [ -z "$userChoice" ]; then
    userChoice=n
  fi
}

##
# Notifies the user of a cancelled installation.
##
installationCancelled() {
  printf "\n
    ${LIGHT_CYAN}  >> cancelled by user, user choice: ${RED}%s
    ${DEFAULT}\n\n" "${1}"
}

##
# Prints installed global npm packages.
##
printInstalledGlobalNpmDependencies() {
  local DEPS
  DEPS=$(sudo npm list -g --depth=0)
  printSuccessTitle "Installed dependencies:"
  # shellcheck disable=SC2059
  printf "\n${DEPS}\n"
}

##
# Installs an npm package globally if it is not installed yet.
##
installGlobalNpmDependency() {
  local DEPENDENCY_NAME
  DEPENDENCY_NAME=$1
  local DEPS
  DEPS=$(sudo npm list -g --depth=0)

  printInfoMessage "Checking if $DEPENDENCY_NAME is installed"
  printGap

  if grep -q "${DEPENDENCY_NAME}"@ <<<"$DEPS"; then
    printSuccessMessage "$DEPENDENCY_NAME is installed"
    printGap
  else
    printWarningMessage "$DEPENDENCY_NAME is not installed"
    printGap

    sudo npm install -g "${DEPENDENCY_NAME}@latest"
  fi
}

##
# Checks if a deb package is installed.
##
checkIfDebPackageIsInstalled() {
  local PACKAGE_EXISTS
  PACKAGE_EXISTS=$(dpkg -s "$1")
  echo "${PACKAGE_EXISTS}"
}

##
# Installs a deb package if it is not installed yet.
##
installDebPackage() {
  local PACKAGE_NAME
  PACKAGE_NAME="$1"

  printInfoMessage "Checking if $PACKAGE_NAME is installed"
  printGap

  local PACKAGE_EXISTS
  PACKAGE_EXISTS=$(checkIfDebPackageIsInstalled "$PACKAGE_NAME")

  if [ -z "${PACKAGE_EXISTS}" ]; then
    printInfoMessage "$PACKAGE_NAME is not installed. Installing the package..."
    printGap

    sudo apt install -y "$1" || exit 15

    # this step is required if bash-completion was not installed prior to this script execution
    if [ "$1" = 'bash-completion' ]; then
      source /etc/bash_completion
    fi
  else
    printSuccessTitle "$PACKAGE_NAME is already installed"
    printGap
  fi
}

##
# Installs a snap package if it is not installed yet.
##
installSnapPackage() {
  local PACKAGE_NAME
  PACKAGE_NAME=$1

  local SNAP_EXISTS
  SNAP_EXISTS=$(snap find "$PACKAGE_NAME")

  if [ "${SNAP_EXISTS}" == "No matching snaps for ""${PACKAGE_NAME}""" ]; then
    printInfoMessage "$PACKAGE_NAME is not installed. Installing the package..."
    printGap

    sudo snap install "$PACKAGE_NAME" --classic || exit 15
  else
    printSuccessTitle "$PACKAGE_NAME is already installed"
    printGap
  fi
}

##
# Installs a debian/snap package that does not require special installation instructions.
##
installPackageViaManager() {
  printInfoTitle "Install $1 via $2"
  printGap
  read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
  defaultUserChoice
  case $userChoice in
  y | Y)
    if [ "$2" == 'apt' ]; then
      installDebPackage "$1"
    elif [ "$2" == 'snap' ]; then
      installSnapPackage "$1"
    else
      printErrorMessage "This package manager is not supported $2"
      exit 15
    fi
    ;;
  n | N)
    installationCancelled "${userChoice}"
    ;;
  *)
    installationCancelled "${userChoice}"
    ;;
  esac
}

##
# Installs Google Chrome.
# https://www.google.com/chrome/index.html
##
installGoogleChrome() {
  printInfoTitle "Install google-chrome-stable"
  printGap
  read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
  defaultUserChoice
  case $userChoice in
  y | Y)
    CHROME_EXISTS=$(checkIfDebPackageIsInstalled google-chrome-stable)
    if [ -z "${CHROME_EXISTS}" ]; then
      printInfoMessage "The package is not installed. Installing the package..."
      printGap

      wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
      echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
      sudo apt update
      installDebPackage "google-chrome-stable"
    else
      printSuccessMessage "The package is already installed."
      printNameAndValue "CHROME_EXISTS" "${CHROME_EXISTS}"
      printGap
    fi
    ;;
  n | N)
    installationCancelled "${userChoice}"
    ;;
  *)
    installationCancelled "${userChoice}"
    ;;
  esac
}

##
# Installs Docker.
# https://www.docker.com/
##
installDocker() {
  printInfoTitle "Install docker"
  printGap
  read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
  defaultUserChoice
  case $userChoice in
  y | Y)
    DOCKER_EXISTS=$(checkIfDebPackageIsInstalled docker-ce)
    if [ -z "${DOCKER_EXISTS}" ]; then
      printInfoMessage "The package is not installed. Installing the package..."
      printGap

      sudo apt remove -y docker docker-engine docker.io

      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

      sudo apt update
      installDebPackage docker-ce

      printInfoMessage "Configuring docker to run without sudo..."
      printGap

      sudo groupadd docker
      sudo usermod -aG docker "$USER"
      newgrp docker
      sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
      sudo chmod g+rwx "$HOME/.docker" -R
    else
      printSuccessMessage "The package is already installed."
      printNameAndValue "DOCKER_EXISTS" "${DOCKER_EXISTS}"
      printGap
    fi
    ;;
  n | N)
    installationCancelled "${userChoice}"
    ;;
  *)
    installationCancelled "${userChoice}"
    ;;
  esac
}

##
# Installs Minikube.
# https://minikube.sigs.k8s.io/docs/
##
installMinikube() {
  printInfoTitle "Install minikube"
  printGap
  read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
  defaultUserChoice
  case $userChoice in
  y | Y)
    MINIKUBE_EXISTS=$(checkIfDebPackageIsInstalled minikube)
    if [ -z "${MINIKUBE_EXISTS}" ]; then
      printInfoMessage "The package is not installed. Installing the package..."
      printGap

      # use a subshell to download curl to the ~/Downloads directory
      (cd ~/Downloads && curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb)
      sudo dpkg -i ~/Downloads/minikube_latest_amd64.deb

      printInfoMessage "Setting up minikube bash completion..."
      printGap

      echo "source <(minikube completion bash)" >>~/.bashrc
    else
      printSuccessMessage "The package is already installed."
      printNameAndValue "MINIKUBE_EXISTS" "${MINIKUBE_EXISTS}"
      printGap
    fi
    ;;
  n | N)
    installationCancelled "${userChoice}"
    ;;
  *)
    installationCancelled "${userChoice}"
    ;;
  esac
}

##
# Installs Kubectl.
# https://kubernetes.io/docs/reference/kubectl/kubectl/
##
installKubectl() {
  printInfoTitle "Install kubectl"
  printGap
  read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
  defaultUserChoice
  case $userChoice in
  y | Y)
    KUBECTL_EXISTS=$(checkIfDebPackageIsInstalled kubectl)
    if [ -z "${KUBECTL_EXISTS}" ]; then
      printInfoMessage "The package is not installed. Installing the package..."
      printGap

      sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
      echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

      sudo apt update
      installDebPackage kubectl

      printInfoMessage "Setting up kubectl bash completion..."
      printGap

      echo "source <(kubectl completion bash)" >>~/.bashrc
    else
      printSuccessMessage "The package is already installed."
      printNameAndValue "KUBECTL_EXISTS" "${KUBECTL_EXISTS}"
      printGap
    fi
    ;;
  n | N)
    installationCancelled "${userChoice}"
    ;;
  *)
    installationCancelled "${userChoice}"
    ;;
  esac
}

##
# Installs Helm.
# https://helm.sh/
##
installHelm() {
  printInfoTitle "Install helm"
  printGap
  read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
  defaultUserChoice
  case $userChoice in
  y | Y)
    installSnapPackage "helm"
    HELM_COMPLETION_INSTALLED=$(find ~/.bashrc -print0 | xargs -0 grep "source <(helm completion bash)" --color=always)
    if [ -z "${HELM_COMPLETION_INSTALLED}" ]; then
      printInfoMessage "Helm bash completion is not configured. Setting up..."
      printGap

      echo "source <(helm completion bash)" >>~/.bashrc
    else
      printSuccessMessage "Helm bash completion is already configured."
      printNameAndValue "HELM_COMPLETION_INSTALLED" "${HELM_COMPLETION_INSTALLED}"
      printGap
    fi
    ;;
  n | N)
    installationCancelled "${userChoice}"
    ;;
  *)
    installationCancelled "${userChoice}"
    ;;
  esac
}

##
# Installs NodeJS.
# https://nodejs.org/en/
##
installNodeJS() {
  printInfoTitle "Install nodejs v16, and build-essential, and update npm to latest version"
  printGap
  read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
  defaultUserChoice
  case $userChoice in
  y | Y)
    NODE_EXISTS=$(checkIfDebPackageIsInstalled nodejs)
    if [ -z "${NODE_EXISTS}" ]; then
      printInfoMessage "The package is not installed. Installing the package..."
      printGap

      curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
      installDebPackage nodejs
      installDebPackage build-essential
      sudo npm install -g npm
    else
      printSuccessMessage "The package is already installed."
      printNameAndValue "NODE_EXISTS" "${NODE_EXISTS}"
      printGap
    fi
    ;;
  n | N)
    installationCancelled "${userChoice}"
    ;;
  *)
    installationCancelled "${userChoice}"
    ;;
  esac
}

##
# Installs global NPM dependencies.
# https://www.npmjs.com/
##
installGlobalNPMDependencies() {
  printInfoTitle "Install global npm dependencies"
  printGap
  read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
  defaultUserChoice
  case $userChoice in
  y | Y)
    printInstalledGlobalNpmDependencies

    declare -A GLOBAL_NPM_DEPENDENCIES=(
      ["@angular/cli"]="@angular/cli"
      ["@compodoc/compodoc"]="@compodoc/compodoc"
      ["@nestjs/cli"]="@nestjs/cli"
      ["@ngxs/cli"]="@ngxs/cli"
      ["@nrwl/cli"]="@nrwl/cli"
      ["asar"]="asar"
      ["@bazel/bazelisk"]="@bazel/bazelisk"
      ["clang-format"]="clang-format"
      ["commitizen"]="commitizen"
      ["corepack"]="corepack"
      ["cz-conventional-changelog"]="cz-conventional-changelog"
      ["firebase-tools"]="firebase-tools"
      ["grpcc"]="grpcc"
      ["madge"]="madge"
      ["npm-check-updates"]="npm-check-updates"
      ["svgo"]="svgo"
      ["typescript"]="typescript"
      ["yarn"]="yarn"
    )

    for GLOBAL_NPM_DEPENDENCY in "${!GLOBAL_NPM_DEPENDENCIES[@]}"; do
      printInfoMessage "Installing global npm dependency $GLOBAL_NPM_DEPENDENCY..."
      printGap

      installGlobalNpmDependency "$GLOBAL_NPM_DEPENDENCY"
    done
    ;;
  n | N)
    installationCancelled "${userChoice}"
    ;;
  *)
    installationCancelled "${userChoice}"
    ;;
  esac
}

##
# Installs Flutter and AVD (Android SDK tools).
# https://flutter.dev/
# https://developer.android.com/studio#cmdline-tools
##
installFlutterAndAVD() {
  printInfoTitle "Install flutter + avd"
  printGap
  read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
  defaultUserChoice
  case $userChoice in
  y | Y)
    installSnapPackage "flutter"
    installAvd
    ;;
  n | N)
    installationCancelled "${userChoice}"
    ;;
  *)
    installationCancelled "${userChoice}"
    ;;
  esac
}

##
# Installs VSCode.
# https://code.visualstudio.com/
##
installVScode() {
  printInfoTitle "Install vscode"
  printGap
  read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless confirmed (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
  defaultUserChoice
  case $userChoice in
  y | Y)
    VSCODE_EXTENSION_EXISTS=$(checkIfDebPackageIsInstalled code)
    if [ -z "${VSCODE_EXTENSION_EXISTS}" ]; then
      printInfoMessage "The package is not installed. Installing the package..."
      printGap

      wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
      sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
      sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
      rm -f packages.microsoft.gpg
      sudo apt update
      installDebPackage code

      declare -A VSCODE_EXTENSIONS=(
        ["atishay-jain.all-autocomplete"]="atishay-jain.all-autocomplete"
        ["johnpapa.angular-essentials"]="johnpapa.angular-essentials"
        ["angular.ng-template"]="angular.ng-template"
        ["johnpapa.angular2"]="johnpapa.angular2"
        ["natewallace.angular2-inline"]="natewallace.angular2-inline"
        ["xaver.clang-format"]="xaver.clang-format"
        ["jasonnutter.vscode-codeowners"]="jasonnutter.vscode-codeowners"
        ["dart-code.dart-code"]="dart-code.dart-code"
        ["ms-azuretools.vscode-docker"]="ms-azuretools.vscode-docker"
        ["mikestead.dotenv"]="mikestead.dotenv"
        ["editorconfig.editorconfig"]="editorconfig.editorconfig"
        ["dbaeumer.vscode-eslint"]="dbaeumer.vscode-eslint"
        ["dart-code.flutter"]="dart-code.flutter"
        ["hashicorp.terraform"]="hashicorp.terraform"
        ["VisualStudioExptTeam.vscodeintellicode"]="VisualStudioExptTeam.vscodeintellicode"
        ["firsttris.vscode-jest-runner"]="firsttris.vscode-jest-runner"
        ["shd101wyy.markdown-preview-enhanced"]="shd101wyy.markdown-preview-enhanced"
        ["pkief.material-icon-theme"]="pkief.material-icon-theme"
        ["tomoyukim.vscode-mermaid-editor"]="tomoyukim.vscode-mermaid-editor"
        ["eg2.vscode-npm-script"]="eg2.vscode-npm-script"
        ["christian-kohler.path-intellisense"]="christian-kohler.path-intellisense"
        ["johnpapa.vscode-peacock"]="johnpapa.vscode-peacock"
        ["esbenp.prettier-vscode"]="esbenp.prettier-vscode"
        ["plex.vscode-protolint"]="plex.vscode-protolint"
        ["rust-lang.rust"]="rust-lang.rust"
        ["foxundermoon.shell-format"]="foxundermoon.shell-format"
        ["timonwong.shellcheck"]="timonwong.shellcheck"
        ["stylelint.vscode-stylelint"]="stylelint.vscode-stylelint"
        ["stepsize.tech-debt-tracker"]="stepsize.tech-debt-tracker"
        ["pmneo.tsimporter"]="pmneo.tsimporter"
        ["visualstudioexptteam.vscodeintellicode"]="visualstudioexptteam.vscodeintellicode"
        ["ghaschel.vscode-angular-html"]="ghaschel.vscode-angular-html"
        ["zxh404.vscode-proto3"]="zxh404.vscode-proto3"
        ["sadesyllas.vscode-workspace-switcher"]="sadesyllas.vscode-workspace-switcher"
        ["redhat.vscode-yaml"]="redhat.vscode-yaml"
        ["nrwl.angular-console"]="nrwl.angular-console"
        ["devondcarew.bazel-code"]="devondcarew.bazel-code"
      )

      printInfoMessage "Installing the vscode extensions..."
      printGap

      for VSCODE_EXTENSION in "${!VSCODE_EXTENSIONS[@]}"; do
        code --install-extension "$VSCODE_EXTENSION"
      done

    else
      printSuccessMessage "The package is already installed."
      printNameAndValue "VSCODE_EXTENSION_EXISTS" "${VSCODE_EXTENSION_EXISTS}"
      printGap
    fi
    ;;
  n | N)
    installationCancelled "${userChoice}"
    ;;
  *)
    installationCancelled "${userChoice}"
    ;;
  esac
}

##
# Installs system dependencies required for subsequent installations.
##
installPackages() {
  printInfoTitle "This script will install dependencies required for development"
  printGap

  printInfoMessage "Updating apt"
  printGap
  sudo apt update

  printInfoMessage "Installing dependencies required for subsequent installations..."
  printGap

  installPackageViaManager "apt-transport-https" "apt"
  installPackageViaManager "ca-certificates" "apt"
  installPackageViaManager "software-properties-common" "apt"
  installPackageViaManager "bash-completion" "apt"
  installPackageViaManager "curl" "apt"
  installPackageViaManager "wget" "apt"
  installPackageViaManager "gnupg2" "apt"
  installPackageViaManager "unzip" "apt"

  printInfoMessage "Installing packages..."
  printGap

  installPackageViaManager "guake" "apt"        # http://guake-project.org/index.html
  installPackageViaManager "tmux" "apt"         # https://en.wikipedia.org/wiki/Tmux
  installPackageViaManager "freerdp2-x11" "apt" # https://packages.debian.org/sid/freerdp2-x11
  installPackageViaManager "git" "apt"          # https://git-scm.com/
  installPackageViaManager "snapd" "apt"        # https://snapcraft.io/snapd
  installPackageViaManager "chromium" "snap"    # https://www.chromium.org/getting-involved/download-chromium/

  installGoogleChrome

  installDocker

  installMinikube

  installKubectl

  installHelm

  installNodeJS

  installGlobalNPMDependencies

  installFlutterAndAVD

  installVScode
}

installPackages
