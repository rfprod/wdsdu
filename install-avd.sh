#!/bin/bash

source utils/colors.sh ''
source utils/print.sh ''

reportUsage() {
  printInfoTitle "<< USAGE >>"
  printUsageTip "bash install-avd.sh ?" "print help"
  printUsageTip "bash install-avd.sh install" "install avd"
  printGap
}

installAvd() {
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

  printInfoTitle "Installing G++ compiler"
  printGap
  sudo apt-get install g++

  printInfoTitle "Installing Open JDK 11"
  printGap
  sudo apt-get install default-jdk openjdk-11-jdk

  printInfoTitle "Configuring JDK"
  printGap
  sudo update-alternatives --config java

  BASHRC_PATH="${HOME}/.bashrc"

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

  printInfoTitle "Downloading (if needed), and unpacking Android SDK Tools"
  printGap
  sudo apt install wget unzip
  if [ ! -f "${SDK_ZIP_PATH}" ]; then
    ##
    # If wget fails find latest here: https://developer.android.com/studio#downloads
    ##
    wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip -O "${SDK_ZIP_PATH}"
  fi
  unzip "${SDK_ZIP_PATH}" -d "${HOME}/Downloads"

  printInfoTitle "Creating Android SDK Tools directory"
  printGap
  mkdir -p "${HOME}/android/sdk/cmdline-tools/latest"

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

  printInfoTitle "Copying ${HOME}/Downloads/cmdline-tools to ${ANDROID_HOME}"
  printGap
  cp -r "${HOME}/Downloads/cmdline-tools/bin" "${HOME}/android/sdk/cmdline-tools/latest"
  cp -r "${HOME}/Downloads/cmdline-tools/lib" "${HOME}/android/sdk/cmdline-tools/latest"
  cp "${HOME}/Downloads/cmdline-tools/source.properties" "${HOME}/android/sdk/cmdline-tools/latest"
  cp "${HOME}/Downloads/cmdline-tools/NOTICE.txt" "${HOME}/android/sdk/cmdline-tools/latest"

  printInfoTitle "Applying ${BASHRC_PATH} changes"
  printGap
  # shellcheck source="$HOME"/.bashrc
  # shellcheck disable=SC1091
  source "$BASHRC_PATH"

  printInfoTitle "Sdk manager: batch accept licenses"
  printGap
  yes | "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --licenses

  printInfoTitle "Installing Android SDK Platform 31 or later, Android SDK Build-Tools 30.0.3 or later, Android Support Repository, Google Repository"
  printGap
  "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --install "tools" "platform-tools" "platforms;android-31" "build-tools;30.0.2" "extras;android;m2repository" "extras;google;m2repository"

  printInfoTitle "Touching /root/.android/repositories.cfg file to avoid missing file error"
  printGap
  sudo mkdir /root/.android || true
  sudo touch /root/.android/repositories.cfg

  printInfoTitle "Installing Android images"
  printGap
  "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager "system-images;android-30;google_apis;x86"

  printInfoTitle "Listing available targets"
  printGap
  "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" list target

  printInfoTitle "Creating avd"
  printGap
  "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" create avd -n api31device -k "system-images;android-30;google_apis;x86"

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
