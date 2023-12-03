#!/bin/bash

source utils/colors.sh ''
source utils/print.sh ''

printUsage() {
  printInfoTitle "<< USAGE ${0} >>"
  printUsageTip "bash install-avd.sh ?" "print help"
  printUsageTip "bash install-avd.sh install" "install avd"
  printGap
}

##
# Lightweight AVD installation.
# Installs SDK tools CLI without Android Studio.
##
installAvd() {
  printInfoTitle "Checking the architecture..."
  printGap

  local ARCH
  ARCH=$(dpkg --print-architecture)

  if [ "$ARCH" = 'amd64' ]; then
    printInfoTitle "Detected architecture: amd64. Installing packages"
    printGap
    sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0 libstdc++6:i386 || sudo apt-get install lib32z1 lib32ncurses5 libbz2-1.0:i386 libstdc++6:i386
  elif [ "$ARCH" = 'i386' ]; then
    printInfoTitle "Detected architecture: i386. Passing step"
    printGap
  fi

  printInfoTitle "Installing the G++ compiler..."
  printGap
  sudo apt-get install g++

  printInfoTitle "Installing the Open JDK 11..."
  printGap
  sudo apt-get install default-jdk openjdk-11-jdk

  printInfoTitle "Configuring the JDK..."
  printGap
  sudo update-alternatives --config java

  local BASHRC_PATH
  BASHRC_PATH="${HOME}/.bashrc"

  printInfoTitle "Setting the JAVA_HOME environment variable..."
  printGap
  local JAVA_HOME_NEW_VALUE
  JAVA_HOME_NEW_VALUE="export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')"
  printInfoMessage "JAVA_HOME, new value: ${JAVA_HOME_NEW_VALUE}"
  printGap
  if grep -q "JAVA_HOME" "${BASHRC_PATH}"; then
    local JAVA_HOME_CURRENT_VALUE
    JAVA_HOME_CURRENT_VALUE=$(grep "^.*JAVA_HOME.*$" "${BASHRC_PATH}")
    printWarningMessage "JAVA_HOME exists, current value: ${JAVA_HOME_CURRENT_VALUE}"
    printGap
  else
    printInfoMessage "JAVA_HOME does not exist, setting value"
    printGap
    {
      echo "# java jdk home"
      echo "export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')"
    } >>"$BASHRC_PATH"
  fi

  local SDK_ZIP_PATH
  SDK_ZIP_PATH="${HOME}/Downloads/commandlinetools-linux-10406996_latest.zip"

  printInfoTitle "Downloading (if needed), and unpacking the Android SDK Tools..."
  printGap
  sudo apt install wget unzip
  if [ ! -f "${SDK_ZIP_PATH}" ]; then
    ##
    # If wget fails find latest here: https://developer.android.com/studio#downloads
    ##
    wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O "${SDK_ZIP_PATH}"
  fi
  unzip "${SDK_ZIP_PATH}" -d "${HOME}/Downloads"

  printInfoTitle "Creating the Android SDK Tools directory..."
  printGap
  mkdir -p "${HOME}/android/sdk/cmdline-tools/latest"

  printInfoTitle "Setting the ANDROID_HOME system environment variable..."
  printGap
  if grep -q "ANDROID_HOME" "${BASHRC_PATH}"; then
    local ANDROID_HOME_CURRENT_VALUE
    ANDROID_HOME_CURRENT_VALUE=$(grep "^.*ANDROID_HOME.*$" "${BASHRC_PATH}")
    printWarningMessage "ANDROID_HOME exists, current value: ${ANDROID_HOME_CURRENT_VALUE}"
    printGap
  else
    printInfoTitle "ANDROID_HOME does not exist, setting the variable..."
    printGap
    {
      echo "# android sdk variables"
      echo "export ANDROID_HOME=~/android/sdk"
    } >>"$BASHRC_PATH"
  fi

  printInfoTitle "Copying ${HOME}/Downloads/cmdline-tools to ${ANDROID_HOME}"
  printGap
  cp -r "${HOME}/Downloads/cmdline-tools/bin" "${HOME}/android/sdk/cmdline-tools/latest"
  cp -r "${HOME}/Downloads/cmdline-tools/lib" "${HOME}/android/sdk/cmdline-tools/latest"
  cp "${HOME}/Downloads/cmdline-tools/source.properties" "${HOME}/android/sdk/cmdline-tools/latest"
  cp "${HOME}/Downloads/cmdline-tools/NOTICE.txt" "${HOME}/android/sdk/cmdline-tools/latest"

  printInfoTitle "Applying ${BASHRC_PATH} changes..."
  printGap
  # shellcheck source="$HOME"/.bashrc
  # shellcheck disable=SC1091
  source "$BASHRC_PATH"

  printInfoTitle "Accepting the SDK manager licenses in bulk..."
  printGap
  yes | "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --licenses

  printInfoTitle "Installing Android SDK Platform 34 or later, Android SDK Build-Tools 34.0.0 or later, Android Support Repository, Google Repository"
  printGap
  "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --install "tools" "platform-tools" "platforms;android-34" "build-tools;34.0.0" "extras;android;m2repository" "extras;google;m2repository"

  printInfoTitle "Touching /root/.android/repositories.cfg file to avoid missing file error"
  printGap
  sudo mkdir -p /root/.android || true
  sudo touch /root/.android/repositories.cfg

  printInfoTitle "Updating Android sdkmanager..."
  printGap
  "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --update

  printInfoTitle "Installing Android images..."
  printGap
  "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager "system-images;android-34;google_apis;x86_64"

  printInfoTitle "Listing available targets..."
  printGap
  "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" list target

  printInfoTitle "Creating an AVD..."
  printGap
  "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" create avd -n api34device -k "system-images;android-34;google_apis;x86_64"

  printInfoTitle "Listing available AVDs..."
  printGap
  "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" list avd

  printSuccessTitle "AVD has been installed successfully."
  printGap

  flutter doctor -v
}

if [ "$1" = "?" ]; then
  printUsage
elif [ "$1" = "install" ]; then
  installAvd
fi
