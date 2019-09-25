##
# Colors:
# DEFAULT, BLACK, DARK_GRAY, RED, LIGHT_RED, GREEN, LIGHT_GREEN, BROWN, YELLOW,
# BLUE, LIGHT_BLUE, PURPLE, LIGHT_PURPLE, CYAN, LIGHT_CYAN, LIGHT_GRAY, WHITE
##
source colors.sh

# user input timeout
WAIT_TIMEOUT=6

# sets default user choice value
function defaultUserChoice() {
  if [ -z "$userChoice" ]; then
    userChoice=y
  fi
}

# sets user choice value to no, used for optional installation
function optionalUserChoice() {
  if [ -z "$userChoice" ]; then
    userChoice=n
  fi
}

# notifies user of next step
function notifyUserOfNextStep() {
  printf "\n\n${LIGHT_BLUE}${1}...${DEFAULT}\n\n"
}

# notifies user of prerequisite installation
function notifyUserOfPrerequisiteInstallation() {
  printf "\n\n${YELLOW} - ${CYAN}${1}...${DEFAULT}\n\n"
}

# notifies user of installation
function notifyUserOfInstallation() {
  printf "\n ${LIGHT_CYAN}  >> ${1} ${DEFAULT} \n\n"
}

# notifies user of cancelled installation
function notifyUserOfCancelledInstallation() {
  printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: ${RED}${1} ${DEFAULT} \n\n"
}

function checkIfPackageIsInstalled () {
  printf "\n ${YELLOW}  >> checking if package ${CYAN}${1}${YELLOW} is installed ${DEFAULT} \n\n"
  PACKAGE_EXISTS=$(dpkg -s $1)
  echo "${PACKAGE_EXISTS}"
  printf "\n\n"
}

notifyUserOfNextStep "This script will install dependencies required for development"

## update apt
notifyUserOfPrerequisiteInstallation "Updating apt"
# TODO: uncomment subsequent line
#sudo apt update

## install dependencies required for subsequent installations
notifyUserOfPrerequisiteInstallation "Installing dependencies required for subsequent installations"
# TODO: uncomment subsequent lines
checkIfPackageIsInstalled apt-transport-https
checkIfPackageIsInstalled ca-certificates
checkIfPackageIsInstalled curl
checkIfPackageIsInstalled software-properties-common
#sudo apt install -y \
#  apt-transport-https \
#  ca-certificates \
#  curl \
#  software-properties-common

## install guake, and tmux
notifyUserOfNextStep "Install guake, and tmux"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
  y|Y )
    # notify user, and install
    notifyUserOfInstallation "installing guake, and tmux"
    checkIfPackageIsInstalled guake
    checkIfPackageIsInstalled tmux
    # TODO: uncomment subsequent line
    #sudo apt install -y guake tmux
    ;;
  n|N )
    # explicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
  * )
    # implicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
esac

## install xfreerdp
notifyUserOfNextStep "Install xfreerdp"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
  y|Y )
    # notify user, and install
    notifyUserOfInstallation "installing xfreerdp"
    checkIfPackageIsInstalled freerdp-x11
    # TODO: uncomment subsequent line
    #sudo apt install -y freerdp-x11
    ;;
  n|N )
    # explicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
  * )
    # implicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
esac

## install chromium-browser
notifyUserOfNextStep "Install chromium-browser"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
  y|Y )
    # notify user, and install
    notifyUserOfInstallation "installing chromium-browser"
    checkIfPackageIsInstalled chromium-browser
    # TODO: uncomment subsequent line
    #sudo apt install -y chromium-browser
    ;;
  n|N )
    # explicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
  * )
    # implicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
esac

## install google-chrome-stable
notifyUserOfNextStep "Install google-chrome-stable"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
  y|Y )
    # notify user, and install
    notifyUserOfInstallation "installing google-chrome-stable"
    checkIfPackageIsInstalled google-chrome-stable
    # TODO: uncomment subsequent lines
    #wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    #echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
    #sudo apt update
    #sudo apt install -y google-chrome-stable
    ;;
  n|N )
    # explicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
  * )
    # implicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
esac

## install git
notifyUserOfNextStep "Install git"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
  y|Y )
    # notify user, and install
    notifyUserOfInstallation "installing git"
    # TODO: uncomment subsequent line
    checkIfPackageIsInstalled git
    #sudo apt install -y git
    ;;
  n|N )
    # explicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
  * )
    # implicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
esac

## install docker stable, remove old first
notifyUserOfNextStep "Install docker"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
  y|Y )
    # notify user, and install
    notifyUserOfInstallation "installing docker"
    checkIfPackageIsInstalled docker-ce
    # TODO: uncomment subsequent lines
    #sudo apt remove -y docker docker-engine docker.io
    #curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    # verify fingerprint optionally: sudo apt-key fingerprint 0EBFCD88
    #sudo add-apt-repository \
    #  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    #  $(lsb_release -cs) \
    #  stable"
    #sudo apt update
    #sudo apt install -y docker-ce
    ;;
  n|N )
    # explicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
  * )
    # implicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
esac

## install heroku cli
notifyUserOfNextStep "Install heroku cli"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
  y|Y )
    # notify user, and install
    notifyUserOfInstallation "installing heroku cli"
    printf "${RED}TODO: check if snap package is installed${DEFAULT} \n\n"
    # TODO: uncomment subsequent line
    #sudo snap install heroku --classic
    ;;
  n|N )
    # explicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
  * )
    # implicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
esac

## install nodejs v8, and build essential for compiling and installing native addons
notifyUserOfNextStep "Install nodejs v8, and build-essential, and update npm to latest version"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
  y|Y )
    # notify user, and install
    notifyUserOfInstallation "installing nodejs v8, build-essential, and updating npm"
    # TODO: uncomment subsequent lines
    checkIfPackageIsInstalled nodejs
    checkIfPackageIsInstalled build-essential
    checkIfPackageIsInstalled npm
    #curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    #sudo apt install -y nodejs
    #sudo apt install -y build-essential
    #sudo npm install -g npm
    ;;
  n|N )
    # explicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
  * )
    # implicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
esac

## install global npm dependencies
notifyUserOfNextStep "Install global npm dependencies"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
  y|Y )
    # notify user, and install
    notifyUserOfInstallation "installing global npm dependencies"

    ## check if dependencies are installed
    DEPS=$(sudo npm list -g --depth=0)
    printf " ${YELLOW} > ${LIGHT_CYAN} installed deps: ${DEFAULT} ${DEPS} \n"

    if grep -q angular/cli@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}@angular/cli installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}@angular/cli is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g @angular/cli@latest
    fi

    if grep -q compodoc/compodoc@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}@compodoc/compodoc installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}@compodoc/compodoc is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g @compodoc/compodoc@latest
    fi

    if grep -q nestjs/cli@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}@nestjs/cli installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}@nestjs/cli is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g @nestjs/cli@latest
    fi

    if grep -q ngxs/cli@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}@ngxs/cli installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}@ngxs/cli is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g @ngxs/cli@latest
    fi

    if grep -q nrwl/schematics@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}@nrwl/schematics installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}@nrwl/schematics is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g @nrwl/schematics@latest
    fi

    if grep -q cz-conventional-changelog@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}cz-conventional-changelog installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}cz-conventional-changelog is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g cz-conventional-changelog@latest
    fi

    if grep -q jscodeshift@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}jscodeshift installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}jscodeshift is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g jscodeshift@latest
    fi

    if grep -q firebase-tools@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}firebase-tools installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}firebase-tools is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g firebase-tools@latest
    fi

    if grep -q gulp-cli@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}gulp-cli installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}gulp-cli is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g gulp-cli@latest
    fi

    if grep -q n@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}n installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}n is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g n@latest
    fi

    if grep -q npm-check-updates@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}npm-check-updates installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}npm-check-updates is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g npm-check-updates@latest
    fi

    if grep -q svgo@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}svgo installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}svgo is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g svgo@latest
    fi

    if grep -q swagger@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}swagger installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}swagger is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g swagger@latest
    fi

    if grep -q typescript@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}typescript installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}typescript is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent line
      #sudo npm install -g typescript@latest
    fi

    if grep -q yarn@ <<<$DEPS; then
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}yarn installed ${DEFAULT}\n"
    else
      printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}yarn is not installed ${DEFAULT}\n"
      # TODO: uncomment subsequent linenodejs
      #sudo npm install -g yarn@latest
    fi
    ;;
  n|N )
    # explicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
  * )
    # implicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
esac

## install vscode
notifyUserOfNextStep "Install vscode"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless confirmed (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
  y|Y )
    # notify user, and install
    notifyUserOfInstallation "installing vscode"
    checkIfPackageIsInstalled code
    # TODO: uncomment subsequent lines
    #wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    #sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    #sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    #sudo apt-get update
    #sudo apt-get install code # or code-insiders

    ## TODO: install vscode packages
    #code --install-extension editorconfig.editorconfig
    #code --install-extension christian-kohler.path-intellisense
    #code --install-extension christian-kohler.npm-intellisense
    #code --install-extension peterjausovec.vscode-docker
    #code --install-extension atishay-jain.all-autocomplete
    #code --install-extension mikestead.dotenv
    #code --install-extension angular.ng-template
    #code --install-extension natewallace.angular2-inline
    #code --install-extension shd101wyy.markdown-preview-enhanced
    #code --install-extension esbenp.prettier-vscode
    #code --install-extension pmneo.tsimporter
    #code --install-extension sadesyllas.vscode-workspace-switcher
    #code --install-extension nrwl.angular-console
    #code --install-extension metatype.copilot-vscode
    ;;
  n|N )
    # explicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
  * )
    # implicitly cancelled by user
    notifyUserOfCancelledInstallation "${userChoice}"
    ;;
esac
