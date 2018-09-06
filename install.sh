# colours
source util-echo_colours.sh
# DEFAULT, BLACK, DARK_GRAY, RED, LIGHT_RED, GREEN, LIGHT_GREEN, BROWN, YELLOW,
# BLUE, LIGHT_BLUE, PURPLE, LIGHT_PURPLE, CYAN, LIGHT_CYAN, LIGHT_GRAY, WHITE

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

printf "\n\n${LIGHT_BLUE}This script will install dependencies required for development...${DEFAULT}\n\n"

## update apt
printf "\n\n${YELLOW} - ${CYAN}Updating apt...${DEFAULT}\n\n"
# TODO: uncomment subsequent line
#sudo apt update

## install dependencies required for subsequent installations
printf "\n\n${YELLOW} - ${CYAN}Install dependencies required for subsequent installations...${DEFAULT}\n\n"
# TODO: uncomment subsequent lines
#sudo apt install -y \
#  apt-transport-https \
#  ca-certificates \
#  curl \
#  software-properties-common

## install guake, and tmux
printf "\n\n${YELLOW} - ${CYAN}Install guake, and tmux...${DEFAULT}\n\n"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing guake, and tmux ${DEFAULT} \n\n"
		# TODO: uncomment subsequent line
		#sudo apt install -y guake tmux
		;;
	n|N )
		# explicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac

## install xfreerdp
printf "\n\n${YELLOW} - ${CYAN}Install xfreerdp...${DEFAULT}\n\n"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing xfreerdp ${DEFAULT} \n\n"
		# TODO: uncomment subsequent line
		#sudo apt install -y freerdp-x11
		;;
	n|N )
		# explicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac

## install chromium-browser
printf "\n\n${YELLOW} - ${CYAN}Install chromium-browser...${DEFAULT}\n\n"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing chromium-browser ${DEFAULT} \n\n"
		# TODO: uncomment subsequent line
		#sudo apt install -y chromium-browser
		;;
	n|N )
		# explicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac

## install google-chrome-stable
printf "\n\n${YELLOW} - ${CYAN}Install google-chrome-stable...${DEFAULT}\n\n"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing google-chrome-stable ${DEFAULT} \n\n"
		# TODO: uncomment subsequent lines
		#wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
		#echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
		#sudo apt update
		#sudo apt install -y google-chrome-stable
		;;
	n|N )
		# explicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac

## install git
printf "\n\n${YELLOW} - ${CYAN}Install git...${DEFAULT}\n\n"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing git ${DEFAULT} \n\n"
		# TODO: uncomment subsequent line
		#sudo apt install -y git
		;;
	n|N )
		# explicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac

## install docker stable, remove old first
printf "\n\n${YELLOW} - ${CYAN}Install docker...${DEFAULT}\n\n"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing docker ${DEFAULT} \n\n"
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
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac

## install heroku cli
printf "\n\n${YELLOW} - ${CYAN}Install heroku cli...${DEFAULT}\n\n"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing heroku cli ${DEFAULT} \n\n"
		# TODO: uncomment subsequent line
		#sudo snap install heroku --classic
		;;
	n|N )
		# explicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac

## install nodejs v8, and build essential for compiling and installing native addons
printf "\n\n${YELLOW} - ${CYAN}Install nodejs v8, and build-essential, and update npm to latest version...${DEFAULT}\n\n"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing nodejs v8, and build-essential ${DEFAULT} \n\n"
		# TODO: uncomment subsequent lines
		#curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
		#sudo apt install -y nodejs
		#sudo apt install -y build-essential
		#sudo npm install -g npm
		;;
	n|N )
		# explicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac

## install global npm dependencies: @angular/cli, firebase-tools, git-stats, git-stats-importer, gulp-cli, n, npm-check-updates, svgo, swagger, typescript
printf "\n\n${YELLOW} - ${CYAN}Install global npm dependencies...\n List: \n- @angular/cli \n- firebase-tools \n- git-stats \n- git-stats-importer \n- gulp-cli \n- n \n- npm-check-updates \n- svgo \n- swagger \n- typescript${DEFAULT}\n\n"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing global npm dependencies ${DEFAULT} \n\n"

		## check if dependencies are installed
		DEPS=$(sudo npm list -g --depth=0)
		printf " ${YELLOW} > ${LIGHT_CYAN} installed deps: ${DEFAULT} ${DEPS} \n"

		if grep -q angular/cli@ <<<$DEPS; then
			printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}@angular/cli installed ${DEFAULT}\n"
		else
			printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}@angular/cli is not installed ${DEFAULT}\n"
			# TODO: uncomment subsequent line
			#sudo npm install -g @angular/cli@latest --unsafe-perm
		fi

		if grep -q firebase-tools@ <<<$DEPS; then
			printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}firebase-tools installed ${DEFAULT}\n"
		else
			printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}firebase-tools is not installed ${DEFAULT}\n"
			# TODO: uncomment subsequent line
			#sudo npm install -g firebase-tools@latest
		fi

		if grep -q git-stats@ <<<$DEPS; then
			printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}git-stats installed ${DEFAULT}\n"
		else
			printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}git-stats is not installed ${DEFAULT}\n"
			# TODO: uncomment subsequent line
			#sudo npm install -g git-stats@latest
		fi

		if grep -q git-stats-importer@ <<<$DEPS; then
			printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${GREEN}git-stats-importer installed ${DEFAULT}\n"
		else
			printf " ${YELLOW} > ${LIGHT_CYAN} dependency check: ${LIGHT_RED}git-stats-importer is not installed ${DEFAULT}\n"
			# TODO: uncomment subsequent line
			#sudo npm install -g git-stats-importer@latest
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
		;;
	n|N )
		# explicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac

## install vscode
printf "\n\n${YELLOW} - ${CYAN}Install vscode...${DEFAULT}\n\n"
read -p "    > confirm, will be installed in $WAIT_TIMEOUT seconds unless confirmed (y/n)?" -t $WAIT_TIMEOUT userChoice
defaultUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing vscode ${DEFAULT} \n\n"
		# TODO: uncomment subsequent lines
		#wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
		#sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
		#sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
		#sudo apt-get update
		#sudo apt-get install code # or code-insiders

		## TODO: install vscode packages
		#code --install-extension editorconfig.editorconfig
		#code --install-extension ionutvmi.path-autocomplete
		#code --install-extension peterjausovec.vscode-docker
		#code --install-extension atishay-jain.all-autocomplete
		#code --install-extension mikestead.dotenv

		;;
	n|N )
		# explicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac

## install sublime stable
printf "\n\n${YELLOW} - ${CYAN}Install sublime stable...${DEFAULT}\n\n"
read -p "    > confirm, will NOT be installed in $WAIT_TIMEOUT seconds unless cancelled (y/n)?" -t $WAIT_TIMEOUT userChoice
optionalUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing sublime stable ${DEFAULT} \n\n"
		# TODO: uncomment subsequent lines
		#wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
		#echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
		#sudo apt update
		#sudo apt install sublime-text

		## TODO: install sublime extensions automatically
		printf "\n${LIGHT_BLUE}You should install the following Sublime packages manually (install Package Control first via Sublime UI):${DEFAULT}\n"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}Package Control${DEFAULT}"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}All Autocomplete${DEFAULT}"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}Angular 2 Snippets (John Papa)${DEFAULT}"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}Babel${DEFAULT}"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}Dockerfile Syntax Highlighting${DEFAULT}"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}EditorConfig${DEFAULT}"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}Gitignored File Excluder${DEFAULT}"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}JavaScript Completions${DEFAULT}"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}JsFormat${DEFAULT}"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}ngx-html-syntax${DEFAULT}"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}SCSS${DEFAULT}"
		printf "\n ${YELLOW}- ${LIGHT_BLUE}Typescript${DEFAULT}\n\n"
		;;
	n|N )
		# explicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac

## install atom
printf "\n\n${YELLOW} - ${CYAN}Install atom...${DEFAULT}\n\n"
read -p "    > confirm, will NOT be installed in $WAIT_TIMEOUT seconds unless confirmed (y/n)?" -t $WAIT_TIMEOUT userChoice
optionalUserChoice
case $userChoice in
	y|Y )
		# notify user, and install
		printf "\n ${LIGHT_CYAN}  >> installing atom ${DEFAULT} \n\n"
		# TODO: uncomment subsequent lines
		#sudo add-apt-repository ppa:webupd8team/atom
		#sudo apt-get update
		#sudo apt-get install atom

		## TODO: install atom packages
		#apm install atom-material-ui
		#apm install atom-material-syntax-dark
		#apm install autocomplete-paths
		#apm install autoclose-html
		#apm install highlight-selected
		#apm install minimap
		#apm install minimap-highlight-selected
		#apm install minimap-bookmarks
		#apm install atom-ide-ui
		#apm install atom-typescript
		#apm install language-docker
		#apm install language-jenkinsfile
		#apm install editorconfig
		#apm install emmet
		;;
	n|N )
		# explicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> cancelled by user, user choice: $userChoice ${DEFAULT} \n"
		;;
	* )
		# implicitly cancelled by user
		printf "\n ${LIGHT_CYAN}  >> installation cancelled, invalid value, user choice: ${RED}$userChoice ${DEFAULT} \n"
		;;
esac
