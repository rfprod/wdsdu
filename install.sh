#!/bin/bash

##
# Colors.
##
# shellcheck source=utils/colors.sh
source utils/colors.sh ''
##
# Print utils.
##
# shellcheck source=utils/print.sh
source utils/print.sh ''

##
# Colors.
##
source install-avd.sh ''

##
# User input timeout.
##
WAIT_TIMEOUT=6

##
# Sets default user choice value.
##
defaultUserChoice() {
  if [ -z "$userChoice" ]; then
    userChoice=y
  fi
}

##
# Sets user choice value to no, used for optional installation.
##
optionalUserChoice() {
  if [ -z "$userChoice" ]; then
    userChoice=n
  fi
}

##
# Notifies user of cancelled installation.
##
notifyUserOfCancelledInstallation() {
  printf "\n
    ${LIGHT_CYAN}  >> cancelled by user, user choice: ${RED}%s
    ${DEFAULT}\n\n" "${1}"
}

##
# Checks if package is installed and takes respective action.
##
checkIfPackageIsInstalledAndInstall() {
  printInfoMessage "Checking if package is installed ${1}"
  printGap

  PACKAGE_EXISTS=$(dpkg -s "$1")
  if [ -z "${PACKAGE_EXISTS}" ]; then
    printErrorTitle "PACKAGE DOES NOT EXIST"
    printInfoMessage "Installing package..."
    printGap

    sudo apt install -y "$1"

    # this step is required if bash-completion was not installed prior to this script execution
    if [ "$1" = 'bash-completion' ]; then
      source /etc/bash_completion
    fi
  else
    printSuccessTitle "PACKAGE EXISTS"
    printGap
  fi
}

##
# Resolves if package is installed only.
##
resolveIfPackageIsInstalled() {
  PACKAGE_EXISTS=$(dpkg -s "$1")
  echo "${PACKAGE_EXISTS}"
}

##
# Notified of installed global npm packages.
##
notifyOfInstalledGlobalNpmDependencies() {
  DEPS=$(sudo npm list -g --depth=0)
  printSuccessTitle "Installed dependencies:"
  # shellcheck disable=SC2059
  printf "\n${DEPS}\n"
}

##
# Checks if global NPM dependency is installed.
##
checkIfGlobalNpmDependencyIsInstalledAndInstall() {
  DEPENDENCY_NAME=$1
  DEPS=$(sudo npm list -g --depth=0)

  printInfoMessage "Dependency check"
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
# Resolves if snap package is installed only.
##
resolveIfSNAPPackageIsInstalled() {
  SNAP_EXISTS=$(snap find "$1")
  if [ "${SNAP_EXISTS}" == "No matching snaps for ""${1}""" ]; then
    printErrorTitle "PACKAGE DOES NOT EXIST"
    printGap
  else
    echo "${SNAP_EXISTS}"
  fi
}

##
# Checks if snap package is installed.
##
checkIfSNAPPackageIsInstalledAndInstall() {
  DEPENDENCY_NAME=$1
  SNAP_EXISTS=$(snap find "$DEPENDENCY_NAME")
  if [ "${SNAP_EXISTS}" == "No matching snaps for ""${DEPENDENCY_NAME}""" ]; then
    printErrorTitle "PACKAGE DOES NOT EXIST"
    printInfoMessage "Installing package..."
    printGap

    sudo snap install "$DEPENDENCY_NAME" --classic
  else
    echo "${SNAP_EXISTS}"
  fi
}

## start
printInfoTitle "This script will install dependencies required for development"
printGap

## update apt
printInfoMessage "Updating apt"
printGap
sudo apt update

## install dependencies required for subsequent installations
printInfoMessage "Installing dependencies required for subsequent installations"
printGap

checkIfPackageIsInstalledAndInstall apt-transport-https
checkIfPackageIsInstalledAndInstall ca-certificates
checkIfPackageIsInstalledAndInstall curl
checkIfPackageIsInstalledAndInstall software-properties-common
checkIfPackageIsInstalledAndInstall bash-completion

## install guake, and tmux
printInfoTitle "Install guake, and tmux"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  printInfoMessage "Installing guake, and tmux"
  printGap

  checkIfPackageIsInstalledAndInstall guake
  checkIfPackageIsInstalledAndInstall tmux
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install freerdp2-x11
printInfoTitle "Install freerdp2-x11"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  printInfoMessage "Installing freerdp2-x11"
  printGap

  checkIfPackageIsInstalledAndInstall freerdp2-x11
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install chromium-browser
printInfoTitle "Install chromium"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  printInfoMessage "Installing chromium-browser"
  printGap

  checkIfSNAPPackageIsInstalledAndInstall "chromium"
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install google-chrome-stable
printInfoTitle "Install google-chrome-stable"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ### notify user, and install
  printInfoMessage "Installing google-chrome-stable"
  printGap

  CHROME_EXISTS=$(resolveIfPackageIsInstalled google-chrome-stable)
  if [ -z "${CHROME_EXISTS}" ]; then
    printWarningMessage "PACKAGE DOES NOT EXIST"
    printInfoMessage "installing package"
    printGap

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
    sudo apt install -y google-chrome-stable
  else
    printSuccessMessage "PACKAGE EXISTS"
    printNameAndValue "CHROME_EXISTS" "$CHROME_EXISTS"
    printGap
  fi
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install git
printInfoTitle "Install git"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  printInfoMessage "Installing git"
  printGap

  checkIfPackageIsInstalledAndInstall git
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install docker stable, remove old first
printInfoTitle "Install docker"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  printInfoMessage "Installing docker"
  printGap
  DOCKER_EXISTS=$(resolveIfPackageIsInstalled docker-ce)
  if [ -z "${DOCKER_EXISTS}" ]; then
    printWarningMessage "PACKAGE DOES NOT EXIST"
    printInfoMessage "installing package..."
    printGap

    sudo apt remove -y docker docker-engine docker.io
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    ## verify fingerprint optionally:
    # sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    sudo apt update
    sudo apt install -y docker-ce

    # add ability to ru docker commands without sudo
    sudo groupadd docker
    sudo usermod -aG docker "$USER"
    newgrp docker
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
  else

    printSuccessMessage "PACKAGE EXISTS"
    printNameAndValue "DOCKER_EXISTS" "${DOCKER_EXISTS}"
    printGap
  fi
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install minikube
printInfoTitle "Install minikube"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  printInfoMessage "Installing minikube"
  printGap
  MINIKUBE_EXISTS=$(resolveIfPackageIsInstalled minikube)
  if [ -z "${MINIKUBE_EXISTS}" ]; then
    printWarningMessage "PACKAGE DOES NOT EXIST"
    printInfoMessage "installing package..."
    printGap

    # use a subshell to download curl to the ~/Downloads directory
    (cd ~/Downloads && curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb)
    sudo dpkg -i ~/Downloads/minikube_latest_amd64.deb
    # set bash autocompletion
    echo "source <(minikube completion bash)" >>~/.bashrc # add autocomplete permanently to your bash shell.
  else
    printSuccessMessage "PACKAGE EXISTS"
    printNameAndValue "MINIKUBE_EXISTS" "${MINIKUBE_EXISTS}"
    printGap
  fi
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install kubectl
printInfoTitle "Install kubectl"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  printInfoMessage "Installing kubectl"
  printGap
  KUBECTL_EXISTS=$(resolveIfPackageIsInstalled kubectl)
  if [ -z "${KUBECTL_EXISTS}" ]; then
    printWarningMessage "PACKAGE DOES NOT EXIST"
    printInfoMessage "installing package..."
    printGap

    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt update
    sudo apt install -y kubectl
    # set bash autocompletion
    echo "source <(kubectl completion bash)" >>~/.bashrc # add autocomplete permanently to your bash shell.
  else
    printSuccessMessage "PACKAGE EXISTS"
    printNameAndValue "KUBECTL_EXISTS" "${KUBECTL_EXISTS}"
    printGap
  fi
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install helm
printInfoTitle "Install helm"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  printInfoMessage "Installing helm"
  printGap
  HELM_EXISTS=$(checkIfSNAPPackageIsInstalledAndInstall helm)
  if [ -z "${HELM_EXISTS}" ]; then
    printWarningMessage "PACKAGE DOES NOT EXIST"
    printInfoMessage "installing package..."
    printGap

    sudo snap install helm --classic
    # set bash autocompletion
    echo "source <(helm completion bash)" >>~/.bashrc # add autocomplete permanently to your bash shell.
  else
    printSuccessMessage "PACKAGE EXISTS"
    printNameAndValue "HELM_EXISTS" "${HELM_EXISTS}"
    printGap
  fi
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install nodejs v14, and build essential for compiling and installing native addons
printInfoTitle "Install nodejs v14, and build-essential, and update npm to latest version"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  printInfoMessage "Installing nodejs v14, build-essential, and updating npm"
  printGap

  NODE_EXISTS=$(resolveIfPackageIsInstalled nodejs)
  if [ -z "${NODE_EXISTS}" ]; then
    printWarningMessage "PACKAGE DOES NOT EXIST"
    printInfoMessage "installing package..."
    printGap

    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt install -y nodejs
    checkIfPackageIsInstalledAndInstall build-essential
    sudo npm install -g npm
  else
    printSuccessMessage "PACKAGE EXISTS"
    printNameAndValue "NODE_EXISTS" "${NODE_EXISTS}"
    printGap
  fi
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install global npm dependencies
printInfoTitle "Install global npm dependencies"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing global npm dependencies"
  printGap

  notifyOfInstalledGlobalNpmDependencies

  checkIfGlobalNpmDependencyIsInstalledAndInstall "bazel"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "clang-format"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "cz-conventional-changelog"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "firebase-tools"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "jscodeshift"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "npm-check-updates"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "svgo"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "typescript"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "yarn"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "@angular/cli"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "@nestjs/cli"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "@ngxs/cli"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "@nrwl/cli"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "@compodoc/compodoc"
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install flutter + avd
printInfoTitle "Install flutter + avd"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  printInfoMessage "Installing flutter"
  printGap

  checkIfPackageIsInstalledAndInstall snapd
  checkIfSNAPPackageIsInstalledAndInstall "flutter"
  installAvd
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac

## install vscode
printInfoTitle "Install vscode"
printGap
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless confirmed (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  printInfoMessage "Installing vscode"
  printGap

  VSCODE_EXTENSION_EXISTS=$(resolveIfPackageIsInstalled code)
  if [ -z "${VSCODE_EXTENSION_EXISTS}" ]; then
    printWarningMessage "PACKAGE DOES NOT EXIST"
    printInfoMessage "installing package..."
    printGap

    wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update
    sudo apt-get install code

    # install vscode packages
    code --install-extension nrwl.angular-console
    code --install-extension angular.ng-template
    code --install-extension johnpapa.angular-essentials
    code --install-extension pkief.material-icon-theme
    code --install-extension atishay-jain.all-autocomplete
    code --install-extension johnpapa.vscode-peacock
    code --install-extension pmneo.tsimporter
    code --install-extension christian-kohler.path-intellisense
    code --install-extension sadesyllas.vscode-workspace-switcher
    code --install-extension editorconfig.editorconfig
    code --install-extension mikestead.dotenv
    code --install-extension shd101wyy.markdown-preview-enhanced
    code --install-extension tomoyukim.vscode-mermaid-editor
    code --install-extension eg2.vscode-npm-script
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension esbenp.prettier-vscode
    code --install-extension ghaschel.vscode-angular-html
    code --install-extension natewallace.angular2-inline
    code --install-extension johnpapa.angular2
    code --install-extension zxh404.vscode-proto3
    code --install-extension plex.vscode-protolint
    code --install-extension xaver.clang-format
    code --install-extension devondcarew.bazel-code
    code --install-extension foxundermoon.shell-format
    code --install-extension timonwong.shellcheck
    code --install-extension stepsize.tech-debt-tracker
    code --install-extension stylelint.vscode-stylelint
    code --install-extension dart-code.dart-code
    code --install-extension dart-code.flutter
  else
    printSuccessMessage "PACKAGE EXISTS"
    printNameAndValue "VSCODE_EXTENSION_EXISTS" "${VSCODE_EXTENSION_EXISTS}"
    printGap
  fi
  ;;
n | N)
  ## explicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
*)
  ## implicitly cancelled by user
  notifyUserOfCancelledInstallation "${userChoice}"
  ;;
esac
