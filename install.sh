#!/bin/bash

source utils/colors.sh ''
source utils/print.sh ''
source install-avd.sh ''

USER_INPUT_TIMEOUT=6

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
installationCancelled() {
  printf "\n
    ${LIGHT_CYAN}  >> cancelled by user, user choice: ${RED}%s
    ${DEFAULT}\n\n" "${1}"
}

##
# Checks if package is installed and takes respective action.
##
installAptPackage() {
  printInfoMessage "Checking if package is installed ${1}"
  printGap

  PACKAGE_EXISTS=$(dpkg -s "$1")
  if [ -z "${PACKAGE_EXISTS}" ]; then
    printErrorTitle "Package does not exist"
    printInfoMessage "Installing package..."
    printGap

    sudo apt install -y "$1"

    # this step is required if bash-completion was not installed prior to this script execution
    if [ "$1" = 'bash-completion' ]; then
      source /etc/bash_completion
    fi
  else
    printSuccessTitle "Package exists"
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
    printErrorTitle "Package does not exist"
    printGap
  else
    echo "${SNAP_EXISTS}"
  fi
}

##
# Checks if snap package is installed.
##
installSnapPackage() {
  DEPENDENCY_NAME=$1
  SNAP_EXISTS=$(snap find "$DEPENDENCY_NAME")
  if [ "${SNAP_EXISTS}" == "No matching snaps for ""${DEPENDENCY_NAME}""" ]; then
    printErrorTitle "Package does not exist"
    printInfoMessage "Installing package..."
    printGap

    sudo snap install "$DEPENDENCY_NAME" --classic
  else
    echo "${SNAP_EXISTS}"
  fi
}

printInfoTitle "This script will install dependencies required for development"
printGap

printInfoMessage "Updating apt"
printGap
sudo apt update

printInfoMessage "Installing dependencies required for subsequent installations"
printGap

installAptPackage apt-transport-https
installAptPackage ca-certificates
installAptPackage curl
installAptPackage software-properties-common
installAptPackage bash-completion

printInfoTitle "Install guake, and tmux"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing guake, and tmux"
  printGap

  installAptPackage guake
  installAptPackage tmux
  ;;
n | N)
  installationCancelled "${userChoice}"
  ;;
*)
  installationCancelled "${userChoice}"
  ;;
esac

printInfoTitle "Install freerdp2-x11"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing freerdp2-x11"
  printGap

  installAptPackage freerdp2-x11
  ;;
n | N)
  installationCancelled "${userChoice}"
  ;;
*)
  installationCancelled "${userChoice}"
  ;;
esac

printInfoTitle "Install chromium"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing chromium-browser"
  printGap

  installSnapPackage "chromium"
  ;;
n | N)
  installationCancelled "${userChoice}"
  ;;
*)
  installationCancelled "${userChoice}"
  ;;
esac

printInfoTitle "Install google-chrome-stable"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing google-chrome-stable"
  printGap

  CHROME_EXISTS=$(resolveIfPackageIsInstalled google-chrome-stable)
  if [ -z "${CHROME_EXISTS}" ]; then
    printWarningMessage "Package does not exist"
    printInfoMessage "installing package"
    printGap

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
    sudo apt install -y google-chrome-stable
  else
    printSuccessMessage "Package exists"
    printNameAndValue "CHROME_EXISTS" "$CHROME_EXISTS"
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

printInfoTitle "Install git"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing git"
  printGap

  installAptPackage git
  ;;
n | N)
  installationCancelled "${userChoice}"
  ;;
*)
  installationCancelled "${userChoice}"
  ;;
esac

printInfoTitle "Install docker"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing docker"
  printGap
  DOCKER_EXISTS=$(resolveIfPackageIsInstalled docker-ce)
  if [ -z "${DOCKER_EXISTS}" ]; then
    printWarningMessage "Package does not exist"
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

    printInfoMessage "configuring docker to run without sudo..."
    printGap

    sudo groupadd docker
    sudo usermod -aG docker "$USER"
    newgrp docker
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
  else

    printSuccessMessage "Package exists"
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

printInfoTitle "Install minikube"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing minikube"
  printGap
  MINIKUBE_EXISTS=$(resolveIfPackageIsInstalled minikube)
  if [ -z "${MINIKUBE_EXISTS}" ]; then
    printWarningMessage "Package does not exist"
    printInfoMessage "installing package..."
    printGap

    # use a subshell to download curl to the ~/Downloads directory
    (cd ~/Downloads && curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb)
    sudo dpkg -i ~/Downloads/minikube_latest_amd64.deb

    printInfoMessage "setting up minikube bash completion..."
    printGap

    echo "source <(minikube completion bash)" >>~/.bashrc
  else
    printSuccessMessage "Package exists"
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

printInfoTitle "Install kubectl"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing kubectl"
  printGap
  KUBECTL_EXISTS=$(resolveIfPackageIsInstalled kubectl)
  if [ -z "${KUBECTL_EXISTS}" ]; then
    printWarningMessage "Package does not exist"
    printInfoMessage "installing package..."
    printGap

    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt update
    sudo apt install -y kubectl

    printInfoMessage "setting up kubectl bash completion..."
    printGap

    echo "source <(kubectl completion bash)" >>~/.bashrc
  else
    printSuccessMessage "Package exists"
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

printInfoTitle "Install helm"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing helm"
  printGap
  HELM_EXISTS=$(installSnapPackage helm)
  if [ -z "${HELM_EXISTS}" ]; then
    printWarningMessage "Package does not exist"
    printInfoMessage "installing package..."
    printGap

    sudo snap install helm --classic

    printInfoMessage "setting up helm bash completion..."
    printGap

    echo "source <(helm completion bash)" >>~/.bashrc
  else
    printSuccessMessage "Package exists"
    printNameAndValue "HELM_EXISTS" "${HELM_EXISTS}"
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

printInfoTitle "Install nodejs v16, and build-essential, and update npm to latest version"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing nodejs v16, build-essential, and updating npm"
  printGap

  NODE_EXISTS=$(resolveIfPackageIsInstalled nodejs)
  if [ -z "${NODE_EXISTS}" ]; then
    printWarningMessage "Package does not exist"
    printInfoMessage "installing package..."
    printGap

    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt install -y nodejs
    installAptPackage build-essential
    sudo npm install -g npm
  else
    printSuccessMessage "Package exists"
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

printInfoTitle "Install global npm dependencies"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing global npm dependencies"
  printGap

  notifyOfInstalledGlobalNpmDependencies

  declare -A GLOBAL_NPM_DEPENDENCIES=(
    ["@angular/cli"]="@angular/cli"
    ["@compodoc/compodoc"]="@compodoc/compodoc"
    ["@nestjs/cli"]="@nestjs/cli"
    ["@ngxs/cli"]="@ngxs/cli"
    ["@nrwl/cli"]="@nrwl/cli"
    ["asar"]="asar"
    ["bazel"]="bazel"
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
    printInfoMessage "installing global npm dependency $GLOBAL_NPM_DEPENDENCY..."
    printGap

    checkIfGlobalNpmDependencyIsInstalledAndInstall "$GLOBAL_NPM_DEPENDENCY"
  done
  ;;
n | N)
  installationCancelled "${userChoice}"
  ;;
*)
  installationCancelled "${userChoice}"
  ;;
esac

printInfoTitle "Install flutter + avd"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless cancelled (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing flutter"
  printGap

  installAptPackage snapd
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

printInfoTitle "Install vscode"
printGap
read -r -p "    > confirm, will be installed in $USER_INPUT_TIMEOUT seconds unless confirmed (y/n)?" -t $USER_INPUT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
y | Y)
  printInfoMessage "Installing vscode"
  printGap

  VSCODE_EXTENSION_EXISTS=$(resolveIfPackageIsInstalled code)
  if [ -z "${VSCODE_EXTENSION_EXISTS}" ]; then
    printWarningMessage "Package does not exist"
    printInfoMessage "installing package..."
    printGap

    wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update
    sudo apt-get install code

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
      ["firsttris.vscode-jest-runner"]="firsttris.vscode-jest-runner"
      ["shd101wyy.markdown-preview-enhanced"]="shd101wyy.markdown-preview-enhanced"
      ["pkief.material-icon-theme"]="pkief.material-icon-theme"
      ["tomoyukim.vscode-mermaid-editor"]="tomoyukim.vscode-mermaid-editor"
      ["eg2.vscode-npm-script"]="eg2.vscode-npm-script"
      ["christian-kohler.path-intellisense"]="christian-kohler.path-intellisense"
      ["johnpapa.vscode-peacock"]="johnpapa.vscode-peacock"
      ["esbenp.prettier-vscode"]="esbenp.prettier-vscode"
      ["plex.vscode-protolint"]="plex.vscode-protolint"
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
      ["rbbit.typescript-hero"]="rbbit.typescript-hero"
    )

    for VSCODE_EXTENSION in "${!VSCODE_EXTENSIONS[@]}"; do
      printInfoMessage "installing vscode extension $VSCODE_EXTENSION..."
      printGap

      code --install-extension "$VSCODE_EXTENSION"
    done

  else
    printSuccessMessage "Package exists"
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
