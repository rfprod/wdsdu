# colours
source util-echo_colours.sh
# DEFAULT, BLACK, DARK_GRAY, RED, LIGHT_RED, GREEN, LIGHT_GREEN, BROWN, YELLOW,
# BLUE, LIGHT_BLUE, PURPLE, LIGHT_PURPLE, CYAN, LIGHT_CYAN, LIGHT_GRAY, WHITE

# TODO: make it more interactive, and verbose

printf "\n\n${LIGHT_BLUE}This script will install dependencies required for development...${DEFAULT}\n\n"


printf "\n\n${YELLOW} - ${CYAN}Updating apt...${DEFAULT}\n\n"
## update apt
#sudo apt update

printf "\n\n${YELLOW} - ${CYAN}Install dependencies required for subsequent installations...${DEFAULT}\n\n"
## install dependencies required for subsequent installations
#sudo apt install \
#  apt-transport-https \
#  ca-certificates \
#  curl \
#  software-properties-common

printf "\n\n${YELLOW} - ${CYAN}Install xfreerdp...${DEFAULT}\n\n"
## install xfreerdp
#sudo apt install freerdp-x11

printf "\n\n${YELLOW} - ${CYAN}Install chromium-browser...${DEFAULT}\n\n"
## install chromium-browser
#sudo apt install chromium-browser

printf "\n\n${YELLOW} - ${CYAN}Install google-chrome-stable...${DEFAULT}\n\n"
## install google-chrome-stable
#wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
#echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
#sudo apt update
#sudo apt install google-chrome-stable

printf "\n\n${YELLOW} - ${CYAN}Install git...${DEFAULT}\n\n"
## install git
#sudo apt install git

printf "\n\n${YELLOW} - ${CYAN}Install nodejs v8, and build essentials...${DEFAULT}\n\n"
## install nodejs v8, and build essential for compiling and installing native addons
#curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
#sudo apt install -y nodejs
#sudo apt install -y build-essential

printf "\n\n${YELLOW} - ${CYAN}Install docker...${DEFAULT}\n\n"
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

printf "\n\n${YELLOW} - ${CYAN}Install heroku cli...${DEFAULT}\n\n"
## install heroku cli
#sudo cnap install heroku --classic

printf "\n\n${YELLOW} - ${CYAN}Install global npm dependencies...${DEFAULT}\n\n"
## check if dependencies are installed
DEPS=$(sudo npm list -g --depth=0)
printf " ${YELLOW} > ${LIGHT_CYAN} installed deps: ${DEFAULT} ${DEPS} \n"

if grep -q angular/cli@ <<<$DEPS; then
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}@angular/cli installed ${DEFAULT}\n"
else
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}@angular/cli is not installed ${DEFAULT}\n"
	# sudo npm install -g @angular/cli@latest --unsafe-perm
fi

if grep -q firebase-tools@ <<<$DEPS; then
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}firebase-tools installed ${DEFAULT}\n"
else
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}firebase-tools is not installed ${DEFAULT}\n"
	# sudo npm install -g firebase-tools@latest
fi

if grep -q git-stats@ <<<$DEPS; then
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}git-stats installed ${DEFAULT}\n"
else
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}git-stats is not installed ${DEFAULT}\n"
	# sudo npm install -g git-stats@latest
fi

if grep -q git-stats-importer@ <<<$DEPS; then
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}git-stats-importer installed ${DEFAULT}\n"
else
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}git-stats-importer is not installed ${DEFAULT}\n"
	# sudo npm install -g git-stats-importer@latest
fi

if grep -q gulp-cli@ <<<$DEPS; then
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}gulp-cli installed ${DEFAULT}\n"
else
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}gulp-cli is not installed ${DEFAULT}\n"
	# sudo npm install -g gulp-cli@latest
fi

if grep -q n@ <<<$DEPS; then
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}n installed ${DEFAULT}\n"
else
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}n is not installed ${DEFAULT}\n"
	# sudo npm install -g n@latest
fi

if grep -q npm-check-updates@ <<<$DEPS; then
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}npm-check-updates installed ${DEFAULT}\n"
else
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}npm-check-updates is not installed ${DEFAULT}\n"
	# sudo npm install -g npm-check-updates@latest
fi

if grep -q nsp@ <<<$DEPS; then
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}nsp installed ${DEFAULT}\n"
else
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}nsp is not installed ${DEFAULT}\n"
	# sudo npm install -g nsp@latest
fi

if grep -q svgo@ <<<$DEPS; then
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}svgo installed ${DEFAULT}\n"
else
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}svgo is not installed ${DEFAULT}\n"
	# sudo npm install -g svgo@latest
fi

if grep -q swagger@ <<<$DEPS; then
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}swagger installed ${DEFAULT}\n"
else
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}swagger is not installed ${DEFAULT}\n"
	# sudo npm install -g swagger@latest
fi

if grep -q typescript@ <<<$DEPS; then
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}typescript installed ${DEFAULT}\n"
else
	printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}typescript is not installed ${DEFAULT}\n"
	# sudo npm install -g typescript@latest
fi

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

printf "\n\n${YELLOW} - ${CYAN}Install sublime stable...${DEFAULT}\n\n"
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
