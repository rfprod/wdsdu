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
# Reports usage error and exits.
##
reportUsage() {
  printInfoTitle "<< USAGE >>"
  printUsageTip "bash install-avd.sh ?" "print help"
  printUsageTip "bash install-avd.sh install" "install avd"
  printGap
}

##
# Install AVD.
##
installAvd() {
  # check architecture
  printInfoTitle "Checking architecture"
  printGap
  ARCH=$(dpkg --print-architecture)

  if [ "$ARCH" = 'amd64' ]; then
    printInfoTitle "Detected architecture: amd64. Installing packages"
    printGap
    sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0 libstdc++6:i386 || sudo apt-get install lib32z1 lib32ncurses5 libbz2-1.0:i386 libstdc++6:i386
  elif [ "$ARCH" = 'i386' ]; then
    printInfoTitle "Detected architecture: i386. Passing step"
    printGap
  fi

  # install G++ compiler
  printInfoTitle "Installing G++ compiler"
  printGap
  sudo apt-get install g++

  # install Open JDK 11
  printInfoTitle "Installing Open JDK 11"
  printGap
  sudo apt-get install default-jdk openjdk-11-jdk

  # configure JDK
  printInfoTitle "Configuring JDK"
  printGap
  sudo update-alternatives --config java

  BASHRC_PATH="${HOME}/.bashrc"

  # set JAVA_HOME
  printInfoTitle "Setting JAVA_HOME system environment variable"
  printGap
  JAVA_HOME_NEW_VALUE="export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')"
  printInfoMessage "JAVA_HOME, new value: ${JAVA_HOME_NEW_VALUE}"
  printGap
  if grep -q "JAVA_HOME" "${BASHRC_PATH}"; then
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

  SDK_ZIP_PATH="${HOME}/Downloads/commandlinetools-linux-7583922_latest.zip"

  # download android sdk tools
  printInfoTitle "Downloading (if needed), and unpacking Android SDK Tools"
  printGap
  sudo apt install wget unzip
  if [ ! -f "${SDK_ZIP_PATH}" ]; then
    ##
    # If wget fails find lates here: https://developer.android.com/studio#downloads
    ##
    wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O "${SDK_ZIP_PATH}"
  fi
  unzip "${SDK_ZIP_PATH}" -d "${HOME}/Downloads"

  # create android sdk tools
  printInfoTitle "Creating Android SDK Tools directory"
  printGap
  mkdir -p "${HOME}/android/sdk/cmdline-tools/latest"

  # set ANDROID_HOME
  printInfoTitle "Setting ANDROID_HOME system environment variable"
  printGap
  if grep -q "ANDROID_HOME" "${BASHRC_PATH}"; then
    ANDROID_HOME_CURRENT_VALUE=$(grep "^.*ANDROID_HOME.*$" "${BASHRC_PATH}")
    printWarningMessage "ANDROID_HOME exists, current value: ${ANDROID_HOME_CURRENT_VALUE}"
    printGap
  else
    printInfoTitle "ANDROID_HOME does not exist, setting value"
    printGap
    {
      echo "# android sdk variables"
      echo "export ANDROID_HOME=~/android/sdk"
    } >>"$BASHRC_PATH"
  fi

  # copy sdk tools
  printInfoTitle "Copying ${HOME}/Downloads/cmdline-tools to ${ANDROID_HOME}"
  printGap
  cp -r "${HOME}/Downloads/cmdline-tools/bin" "${HOME}/android/sdk/cmdline-tools/latest"
  cp -r "${HOME}/Downloads/cmdline-tools/lib" "${HOME}/android/sdk/cmdline-tools/latest"
  cp "${HOME}/Downloads/cmdline-tools/source.properties" "${HOME}/android/sdk/cmdline-tools/latest"
  cp "${HOME}/Downloads/cmdline-tools/NOTICE.txt" "${HOME}/android/sdk/cmdline-tools/latest"

  # apply .bashrc changes
  printInfoTitle "Applying ${BASHRC_PATH} changes"
  printGap
  # shellcheck source="$HOME"/.bashrc
  # shellcheck disable=SC1091
  source "$BASHRC_PATH"

  # batch accept licenses
  printInfoTitle "Sdk manager: batch accept licenses"
  printGap
  yes | "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --licenses

  # install sdk tools
  printInfoTitle "Installing Android SDK Platform 29 or later, Android SDK Build-Tools 28.0.3 or later, Android Support Repository, Google Repository"
  printGap
  "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --install "tools" "platform-tools" "platforms;android-29" "build-tools;28.0.3" "extras;android;m2repository" "extras;google;m2repository"

  # touch repositories config to avoid getting error about /root/.android/repositories.cfg missing
  printInfoTitle "Touching /root/.android/repositories.cfg file to avoid missing file error"
  printGap
  sudo mkdir /root/.android || true
  sudo touch /root/.android/repositories.cfg

  # install images
  printInfoTitle "Installing Android images"
  printGap
  "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager "system-images;android-25;google_apis;x86"

  # list available targets
  printInfoTitle "Listing available targets"
  printGap
  "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" list target

  # create avd
  printInfoTitle "Creating avd"
  printGap
  "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" create avd -n api25device -k "system-images;android-25;google_apis;x86"

  # list created avds
  printInfoTitle "Listing available avds"
  printGap
  "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" list avd

  printSuccessTitle "AVD was successfully installed"

  flutter doctor -v
}

if [ "$1" = "?" ]; then
  reportUsage
elif [ "$1" = "install" ]; then
  installAvd
fi
