#!/bin/bash

##
# Colors.
##
source colors.sh ''

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
# Notifies user of next step.
##
notifyUserOfNextStep() {
  printf "\n
    ${LIGHT_BLUE}%s...
    ${DEFAULT}\n\n" "${1}"
}

##
# Notifies user of prerequisite installation.
##
notifyUserOfPrerequisiteInstallation() {
  printf "\n
    ${YELLOW} - ${CYAN}%s...
    ${DEFAULT}\n\n" "${1}"
}

##
# Notifies user of installation.
##
notifyUserOfInstallation() {
  printf "\n
    ${LIGHT_CYAN} >> %s
    ${DEFAULT}\n\n" "${1}"
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
  printf "\n
    ${YELLOW} >> checking if package is installed: ${CYAN}%s
    ${DEFAULT}\n\n" "${1}"
  PACKAGE_EXISTS=$(dpkg -s "$1")
  if [ -z "${PACKAGE_EXISTS}" ]; then
    local TITLE="PACKAGE DOES NOT EXIST"
    printf "\n
      ${RED}%s
      ${DEFAULT}\n
      installing package...
      \n\n" "$TITLE"
    sudo apt install -y "$1"
  else
    local TITLE="PACKAGE EXISTS"
    printf "\n
      ${GREEN}%s
      ${PACKAGE_EXISTS}\n
      ${DEFAULT}\n" "$TITLE"
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
  local TITLE="installed dependencies:"
  printf "\n
    ${YELLOW} > ${LIGHT_CYAN} %s${DEFAULT}\n
    ${DEPS}\n
    ${DEFAULT}\n" "$TITLE"
}

##
# Chacks if global NPM dependency is installed.
##
checkIfGlobalNpmDependencyIsInstalledAndInstall() {
  DEPENDENCY_NAME=$1
  DEPS=$(sudo npm list -g --depth=0)
  local TITLE="dependency check"
  if grep -q "${DEPENDENCY_NAME}"@ <<<"$DEPS"; then
    printf "
      ${YELLOW} > ${LIGHT_CYAN} %s: ${GREEN}${DEPENDENCY_NAME} installed ${DEFAULT}\n" "$TITLE"
  else
    printf "
      ${YELLOW} > ${LIGHT_CYAN} %s: ${LIGHT_RED}${DEPENDENCY_NAME} is not installed ${DEFAULT}\n" "$TITLE"

    sudo npm install -g "${DEPENDENCY_NAME}@latest"
  fi
}

##
# Resolves if snap package is installed only.
##
resolveIfSNAPPackageIsInstalled() {
  SNAP_EXISTS=$(snap find "$1")
  if [ "${SNAP_EXISTS}" == "No matching snaps for ""${1}""" ]; then
    local TITLE="PACKAGE DOES NOT EXIST"
    printf "\n
      ${RED}%s${DEFAULT}\n
      installing package...
      ${DEFAULT}\n\n" "$TITLE"
  else
    echo "${SNAP_EXISTS}"
  fi
}

## start
notifyUserOfNextStep "This script will install dependencies required for development"

## update apt
notifyUserOfPrerequisiteInstallation "Updating apt"
sudo apt update

## install dependencies required for subsequent installations
notifyUserOfPrerequisiteInstallation "Installing dependencies required for subsequent installations"
checkIfPackageIsInstalledAndInstall apt-transport-https
checkIfPackageIsInstalledAndInstall ca-certificates
checkIfPackageIsInstalledAndInstall curl
checkIfPackageIsInstalledAndInstall software-properties-common

## install guake, and tmux
notifyUserOfNextStep "Install guake, and tmux"
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  notifyUserOfInstallation "installing guake, and tmux"
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
notifyUserOfNextStep "Install freerdp2-x11"
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  notifyUserOfInstallation "installing freerdp2-x11"
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
notifyUserOfNextStep "Install chromium-browser"
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  notifyUserOfInstallation "installing chromium-browser"
  checkIfPackageIsInstalledAndInstall chromium-browser
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
notifyUserOfNextStep "Install google-chrome-stable"
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ### notify user, and install
  notifyUserOfInstallation "installing google-chrome-stable"
  CHROME_EXISTS=$(resolveIfPackageIsInstalled google-chrome-stable)
  if [ -z "${CHROME_EXISTS}" ]; then
    TITLE="PACKAGE DOES NOT EXIST"
    printf "\n
        ${RED}%s\n
        ${LIGHT_GREEN}installing package...\n
        ${DEFAULT}\n\n" "$TITLE"

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
    sudo apt install -y google-chrome-stable
  else
    TITLE="PACKAGE EXISTS"
    printf "\n
        ${GREEN}%s\n
        ${CHROME_EXISTS}\n
        ${DEFAULT}\n\n" "$TITLE"
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
notifyUserOfNextStep "Install git"
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  notifyUserOfInstallation "installing git"
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
notifyUserOfNextStep "Install docker"
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  notifyUserOfInstallation "installing docker"
  DOCKER_EXISTS=$(resolveIfPackageIsInstalled docker-ce)
  if [ -z "${DOCKER_EXISTS}" ]; then
    TITLE="PACKAGE DOES NOT EXIST"
    printf "\n
        ${RED}%s\n
        ${LIGHT_GREEN}installing package...\n
        ${DEFAULT}\n\n" "$TITLE"

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
  else
    TITLE="PACKAGE EXISTS"
    printf "\n
        ${GREEN}%s\n
        ${DOCKER_EXISTS}\n
        ${DEFAULT}\n\n" "$TITLE"
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

## install heroku cli
notifyUserOfNextStep "Install heroku cli"
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  notifyUserOfInstallation "installing heroku cli"
  checkIfPackageIsInstalledAndInstall snapd
  HEROKU_EXISTS=$(resolveIfSNAPPackageIsInstalled heroku)
  if [ -z "${HEROKU_EXISTS}" ]; then
    TITLE="PACKAGE DOES NOT EXIST"
    printf "\n
        ${RED}%s\n
        ${LIGHT_GREEN}installing package...\n
        ${DEFAULT}\n\n" "$TITLE"
    sudo snap install heroku --classic
  else
    TITLE="PACKAGE EXISTS"
    printf "\n
        ${GREEN}%s\n
        ${HEROKU_EXISTS}\n
        ${DEFAULT}\n\n" "$TITLE"
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

## install nodejs v10, and build essential for compiling and installing native addons
notifyUserOfNextStep "Install nodejs v10, and build-essential, and update npm to latest version"
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  notifyUserOfInstallation "installing nodejs v10, build-essential, and updating npm"
  NODE_EXISTS=$(resolveIfPackageIsInstalled nodejs)
  if [ -z "${NODE_EXISTS}" ]; then
    TITLE="PACKAGE DOES NOT EXIST"
    printf "\n
        ${RED}%s\n
        ${LIGHT_GREEN}installing package...\n
        ${DEFAULT}\n\n" "$TITLE"

    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt install -y nodejs
    checkIfPackageIsInstalledAndInstall build-essential
    sudo npm install -g npm
  else
    TITLE="PACKAGE EXISTS"
    printf "\n
        ${GREEN}%s\n
        ${NODE_EXISTS}\n
        ${DEFAULT}\n\n" "$TITLE"
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
notifyUserOfNextStep "Install global npm dependencies"
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  notifyUserOfInstallation "installing global npm dependencies"

  notifyOfInstalledGlobalNpmDependencies

  checkIfGlobalNpmDependencyIsInstalledAndInstall "@angular/cli"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "bazel"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "clang-format"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "@compodoc/compodoc"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "@nestjs/cli"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "@ngxs/cli"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "@nrwl/schematics"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "cz-conventional-changelog"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "jscodeshift"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "firebase-tools"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "gulp-cli"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "n"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "npm-check-updates"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "svgo"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "swagger"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "typescript"
  checkIfGlobalNpmDependencyIsInstalledAndInstall "yarn"
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
notifyUserOfNextStep "Install vscode"
read -r -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless confirmed (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  ## notify user, and install
  notifyUserOfInstallation "installing vscode"
  NODE_EXISTS=$(resolveIfPackageIsInstalled code)
  if [ -z "${NODE_EXISTS}" ]; then
    TITLE="PACKAGE DOES NOT EXIST"
    printf "\n
        ${RED}%s\n
        ${LIGHT_GREEN}installing package...\n
        ${DEFAULT}\n\n" "$TITLE"

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
    code --install-extension metatype.copilot-vscode
    code --install-extension sadesyllas.vscode-workspace-switcher
    code --install-extension editorconfig.editorconfig
    code --install-extension mikestead.dotenv
    code --install-extension shd101wyy.markdown-preview-enhanced
    code --install-extension eg2.vscode-npm-script
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension esbenp.prettier-vscode
    code --install-extension ms-vscode.vscode-typescript-tslint-plugin
    code --install-extension ghaschel.vscode-angular-html
    code --install-extension natewallace.angular2-inline
    code --install-extension johnpapa.angular2
    code --install-extension zxh404.vscode-proto3
    code --install-extension plex.vscode-protolint
    code --install-extension xaver.clang-format
    code --install-extension devondcarew.bazel-code
  else
    TITLE="PACKAGE EXISTS"
    printf "\n
        ${GREEN}%s\n
        ${NODE_EXISTS}\n
        ${DEFAULT}\n\n" "$TITLE"
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
