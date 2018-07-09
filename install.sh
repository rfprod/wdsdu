# colours
source util-echo_colours.sh
# DEFAULT, BLACK, DARK_GRAY, RED, LIGHT_RED, GREEN, LIGHT_GREEN, BROWN, YELLOW,
# BLUE, LIGHT_BLUE, PURPLE, LIGHT_PURPLE, CYAN, LIGHT_CYAN, LIGHT_GRAY, WHITE

# TODO: make it more interactive, and verbose

printf "\n\n${LIGHT_BLUE}This script will install dependencies required for development...${DEFAULT}\n\n"

## update apt
#sudo apt update

## install dependencies required for subsequent installations
#sudo apt install \
#  apt-transport-https \
#  ca-certificates \
#  curl \
#  software-properties-common

## install xfreerdp
#sudo apt install freerdp-x11

## install chromium-browser
#sudo apt install chromium-browser

## install google-chrome-stable
#wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
#echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
#sudo apt update
#sudo apt install google-chrome-stable

## install git
#sudo apt install git

## install nodejs v8, and build essential for compiling and installing native addons
#curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
#sudo apt install -y nodejs
#sudo apt install -y build-essential

## install docker stable, remove old first
#sudo apt remove docker docker-engine docker.io
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# verify fingerprint optionally: sudo apt-key fingerprint 0EBFCD88
#sudo add-apt-repository \
#  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#  $(lsb_release -cs) \
#  stable"
#sudo apt update
#sudo apt install docker-ce

## install heroku cli
#sudo cnap install heroku --classic

## install global npm dependencies
#sudo npm install -g @angular/cli --unsafe-perm
#sudo npm install -g firebase-tools
#sudo npm install -g git-stats git-stats-importer
#sudo npm install -g gulp-cli
#sudo npm install -g n
#sudo npm install -g npm-check-updates
#sudo npm install -g nsp
#sudo npm install -g svgo
#sudo npm install -g swagger
#sudo npm install -g typescript

## install sublime stable
#wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
#echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
#sudo apt update
#sudo apt install sublime-text

printf "\n${LIGHT_BLUE}You should install the following Sublime packages manually (install Package Control first via Sublime UI):${DEFAULT}\n"
printf "\n ${YELLOW}- ${LIGHT_BLUE}Angular 2 Snippets (John Papa)${DEFAULT}"
printf "\n ${YELLOW}- ${LIGHT_BLUE}Dockerfile Syntax Highlighting${DEFAULT}"
printf "\n ${YELLOW}- ${LIGHT_BLUE}EditorConfig${DEFAULT}"
printf "\n ${YELLOW}- ${LIGHT_BLUE}Gitignored File Excluder${DEFAULT}"
printf "\n ${YELLOW}- ${LIGHT_BLUE}JavaScriptNext - ES6 Syntax${DEFAULT}"
printf "\n ${YELLOW}- ${LIGHT_BLUE}JsFormat${DEFAULT}"
printf "\n ${YELLOW}- ${LIGHT_BLUE}MarkdownPreview${DEFAULT}"
printf "\n ${YELLOW}- ${LIGHT_BLUE}ngx-html-syntax${DEFAULT}"
printf "\n ${YELLOW}- ${LIGHT_BLUE}SCSS${DEFAULT}"
printf "\n ${YELLOW}- ${LIGHT_BLUE}Typescript${DEFAULT}\n\n"
