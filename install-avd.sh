#!/bin/bash

##
# Colors.
##
source colors.sh ''

##
# Reports usage error and exits.
##
reportUsage() {
  local TITLE="<< USAGE >>"
  printf "
    ${LIGHT_BLUE}%s\n
    ${DEFAULT} - ${YELLOW} bash install-avd.sh ?${DEFAULT} - print help
    ${DEFAULT} - ${YELLOW} bash install-avd.sh install${DEFAULT} installs avd
    ${DEFAULT}\n\n" "$TITLE"
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
# Notifies user of next step.
##
notifyUserOfProgress() {
  printf "\n
    ${CYAN}%s
    ${DEFAULT}\n\n" "${1}"
}

##
# Notifies user of success.
##
notifyUserOfSuccess() {
  printf "\n
    ${GREEN}%s
    ${DEFAULT}" "${1}"
}

##
# Install AVD.
##
installAvd() {

  # check architecture
  notifyUserOfNextStep "Checking architecture"
  ARCH=$(dpkg --print-architecture)
  if [ "$ARCH" = 'amd64' ]; then
    notifyUserOfNextStep "Detected architecture: amd64. Installing packages"
    sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0 libstdc++6:i386 || sudo apt-get install lib32z1 lib32ncurses5 libbz2-1.0:i386 libstdc++6:i386
  elif [ "$ARCH" = 'i386' ]; then
    notifyUserOfNextStep "Detected architecture: i386. Passing step"
  fi

  # install G++ compiler
  notifyUserOfNextStep "Installing G++ compiler"
  sudo apt-get install g++

  # install JDK 8+
  notifyUserOfNextStep "Installing JDK 8"
  sudo apt-get install python-software-properties
  sudo add-apt-repository ppa:webupd8team/java
  sudo apt-get update
  sudo apt-get install oracle-java8-installer

  # configure JDK
  notifyUserOfNextStep "Configuring JDK"
  sudo update-alternatives --config java

  BASHRC_PATH="${HOME}/.bashrc"

  # set JAVA_HOME
  notifyUserOfNextStep "Setting JAVA_HOME system environment variable"
  JAVA_HOME_NEW_VALUE="export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')"
  notifyUserOfProgress "JAVA_HOME, new value: ${JAVA_HOME_NEW_VALUE}"
  if grep -q "JAVA_HOME" "${BASHRC_PATH}"; then
    JAVA_HOME_CURRENT_VALUE=$(grep "^.*JAVA_HOME.*$" "${BASHRC_PATH}")
    notifyUserOfProgress "JAVA_HOME exists, current value: ${JAVA_HOME_CURRENT_VALUE}"
    notifyUserOfProgress "Backing up ${BASHRC_PATH}"
    cp "${BASHRC_PATH}" "${HOME}/.bashrc-custom-tns-installer-backup-0"
    find "${BASHRC_PATH}" -exec sed -i "s/^.*JAVA_HOME.*$/$JAVA_HOME_NEW_VALUE/g" {} \;
  else
    notifyUserOfProgress "JAVA_HOME does not exist, setting value"
    {
      echo "# java jdk home"
      echo "export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')"
    } >>"$BASHRC_PATH"
  fi

  SDK_ZIP_PATH="${HOME}/Downloads/sdk-tools-linux-3859397.zip"

  # download android sdk tools
  notifyUserOfNextStep "Downloading (if needed), and unpacking Android SDK Tools"
  sudo apt install wget unzip
  if [ ! -f "${SDK_ZIP_PATH}" ]; then
    ##
    # If wget fails find lates here: https://developer.android.com/studio#downloads
    ##
    wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip -O "${SDK_ZIP_PATH}"
  fi
  unzip "${SDK_ZIP_PATH}" -d "${HOME}/Downloads"

  # create android sdk tools
  notifyUserOfNextStep "Creating Android SDK Tools directory"
  sudo mkdir /usr/share/android
  sudo mkdir /usr/share/android/sdk

  # set ANDROID_HOME
  notifyUserOfNextStep "Setting ANDROID_HOME system environment variable"
  if grep -q "ANDROID_HOME" "${BASHRC_PATH}"; then
    ANDROID_HOME_CURRENT_VALUE=$(grep "^.*ANDROID_HOME.*$" "${BASHRC_PATH}")
    notifyUserOfProgress "ANDROID_HOME exists, current value: ${ANDROID_HOME_CURRENT_VALUE}"
    notifyUserOfProgress "Backing up ${BASHRC_PATH}"
    cp "${BASHRC_PATH}" "${HOME}/.bashrc-custom-tns-installer-backup-1"
    ANDROID_HOME_NEW_VALUE="export ANDROID_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')"
    notifyUserOfProgress "ANDROID_HOME, new value: ${ANDROID_HOME_NEW_VALUE}"
    find "${BASHRC_PATH}" -exec sed -i "s/^.*ANDROID_HOME.*$/$ANDROID_HOME_NEW_VALUE/g" {} \;
  else
    notifyUserOfNextStep "ANDROID_HOME does not exist, setting value"
    {
      echo "# android sdk variables"
      echo "export ANDROID_HOME=/usr/share/android/sdk"
    } >>"$BASHRC_PATH"
  fi

  # apply .bashrc changes
  notifyUserOfNextStep "Applying ${BASHRC_PATH} changes"
  # shellcheck source="$HOME"/.bashrc
  # shellcheck disable=SC1091
  source "$BASHRC_PATH"

  # copy sdk tools
  notifyUserOfNextStep "Copying ${HOME}/Downloads/tools to ${ANDROID_HOME}"
  sudo cp -r "${HOME}/Downloads/tools" "$ANDROID_HOME"/

  # install sdk tools
  notifyUserOfNextStep "Installing Android SDK Platform 25, Android SDK Build-Tools 25.0.2 or later, Android Support Repository, Google Repository"
  sudo "$ANDROID_HOME"/tools/bin/sdkmanager --install "tools" "platform-tools" "platforms;android-29" "build-tools;28.0.2" "extras;android;m2repository" "extras;google;m2repository"

  # batch accept licenses
  notifyUserOfNextStep "Sdk manager: batch accept licenses"
  yes | sudo "$ANDROID_HOME"/tools/bin/sdkmanager --licenses

  # touch repositories config to avoid getting error about /root/.android/repositories.cfg missing
  notifyUserOfNextStep "Touching /root/.android/repositories.cfg file to avoid missing file error"
  sudo touch /root/.android/repositories.cfg

  # install images
  notifyUserOfNextStep "Installing Android images"
  sudo "$ANDROID_HOME"/tools/bin/sdkmanager "system-images;android-25;google_apis;x86"

  # list available targets
  notifyUserOfNextStep "Listing available targets"
  android list target

  # create avd
  notifyUserOfNextStep "Creating avd"
  android create avd -n api25device -k "system-images;android-25;google_apis;x86"

  # list created avds
  notifyUserOfNextStep "Listing available avds"
  android list avd

  notifyUserOfSuccess "AVD was successfully installed"
}

if [ "$1" = "?" ]; then
  reportUsage
elif [ "$1" = "install" ]; then
  installAvd
fi
