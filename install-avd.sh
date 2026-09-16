#!/bin/bash


# shellcheck source=utils/error-handler.sh
source utils/error-handler.sh

install_error_handler

# shellcheck source=utils/colors.sh
source utils/colors.sh ''

# shellcheck source=utils/print.sh
source utils/print.sh ''

print_usage() {
  print_info_title "<< USAGE ${0} >>"
  print_usage_tip "bash install-avd.sh ?" "print help"
  print_usage_tip "bash install-avd.sh install" "install avd"
  print_gap
}

##
# Lightweight AVD installation.
# Installs SDK tools CLI without Android Studio.
##
install_avd() {
  print_info_title "Checking the architecture..."
  print_gap

  local ARCH
  ARCH=$(dpkg --print-architecture)

  if [ "$ARCH" = 'amd64' ]; then
    print_info_title "Detected architecture: amd64. Installing packages"
    print_gap
    sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0 libstdc++6:i386 || sudo apt-get install lib32z1 lib32ncurses5 libbz2-1.0:i386 libstdc++6:i386
  elif [ "$ARCH" = 'i386' ]; then
    print_info_title "Detected architecture: i386. Passing step"
    print_gap
  fi

  print_info_title "Installing the G++ compiler..."
  print_gap
  sudo apt-get install g++

  print_info_title "Installing the Open JDK 11 and 17..."
  print_gap
  sudo apt-get install default-jdk openjdk-11-jdk openjdk-17-jdk

  print_info_title "Configuring the JDK..."
  print_gap
  sudo update-alternatives --config java

  local BASHRC_PATH
  BASHRC_PATH="${HOME}/.bashrc"

  print_info_title "Setting the JAVA_HOME environment variable..."
  print_gap
  local JAVA_HOME_NEW_VALUE
  JAVA_HOME_NEW_VALUE="export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')"
  print_info_message "JAVA_HOME, new value: ${JAVA_HOME_NEW_VALUE}"
  print_gap
  if grep -q "JAVA_HOME" "${BASHRC_PATH}"; then
    local JAVA_HOME_CURRENT_VALUE
    JAVA_HOME_CURRENT_VALUE=$(grep "^.*JAVA_HOME.*$" "${BASHRC_PATH}")
    print_warning_message "JAVA_HOME exists, current value: ${JAVA_HOME_CURRENT_VALUE}"
    print_gap
  else
    print_info_message "JAVA_HOME does not exist, setting value"
    print_gap
    {
      echo "# java jdk home"
      echo "export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')"
    } >>"$BASHRC_PATH"
  fi

  local SDK_ZIP_PATH
  SDK_ZIP_PATH="${HOME}/Downloads/commandlinetools-linux-10406996_latest.zip"

  print_info_title "Downloading (if needed), and unpacking the Android SDK Tools..."
  print_gap
  sudo apt install wget unzip
  if [ ! -f "${SDK_ZIP_PATH}" ]; then
    ##
    # If wget fails find latest here: https://developer.android.com/studio#downloads
    ##
    wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O "${SDK_ZIP_PATH}"
  fi
  unzip "${SDK_ZIP_PATH}" -d "${HOME}/Downloads"

  print_info_title "Creating the Android SDK Tools directory..."
  print_gap
  mkdir -p "${HOME}/android/sdk/cmdline-tools/latest"

  print_info_title "Setting the ANDROID_HOME system environment variable..."
  print_gap
  if grep -q "ANDROID_HOME" "${BASHRC_PATH}"; then
    local ANDROID_HOME_CURRENT_VALUE
    ANDROID_HOME_CURRENT_VALUE=$(grep "^.*ANDROID_HOME.*$" "${BASHRC_PATH}")
    print_warning_message "ANDROID_HOME exists, current value: ${ANDROID_HOME_CURRENT_VALUE}"
    print_gap
  else
    print_info_title "ANDROID_HOME does not exist, setting the variable..."
    print_gap
    {
      echo "# android sdk variables"
      echo "export ANDROID_HOME=~/android/sdk"
    } >>"$BASHRC_PATH"
  fi

  print_info_title "Copying ${HOME}/Downloads/cmdline-tools to ${ANDROID_HOME}"
  print_gap
  cp -r "${HOME}/Downloads/cmdline-tools/bin" "${HOME}/android/sdk/cmdline-tools/latest"
  cp -r "${HOME}/Downloads/cmdline-tools/lib" "${HOME}/android/sdk/cmdline-tools/latest"
  cp "${HOME}/Downloads/cmdline-tools/source.properties" "${HOME}/android/sdk/cmdline-tools/latest"
  cp "${HOME}/Downloads/cmdline-tools/NOTICE.txt" "${HOME}/android/sdk/cmdline-tools/latest"

  print_info_title "Applying ${BASHRC_PATH} changes..."
  print_gap
  # shellcheck source="$HOME/.bashrc"
  # shellcheck disable=SC1091
  source "$BASHRC_PATH"

  print_info_title "Accepting the SDK manager licenses in bulk..."
  print_gap
  yes | "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --licenses

  print_info_title "Installing Android SDK Platform 34 or later, Android SDK Build-Tools 34.0.0 or later, Android Support Repository, Google Repository"
  print_gap
  "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --install "tools" "platform-tools" "platforms;android-34" "build-tools;34.0.0" "extras;android;m2repository" "extras;google;m2repository"

  print_info_title "Touching /root/.android/repositories.cfg file to avoid missing file error"
  print_gap
  sudo mkdir -p /root/.android || true
  sudo touch /root/.android/repositories.cfg

  print_info_title "Updating Android sdkmanager..."
  print_gap
  "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --update

  print_info_title "Installing Android images..."
  print_gap
  "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager "system-images;android-34;google_apis;x86_64"

  print_info_title "Listing available targets..."
  print_gap
  "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" list target

  print_info_title "Creating an AVD..."
  print_gap
  "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" create avd -n api34device -k "system-images;android-34;google_apis;x86_64"

  print_info_title "Listing available AVDs..."
  print_gap
  "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" list avd

  print_success_title "AVD has been installed successfully."
  print_gap

  flutter doctor -v
}

if [ "$1" = "?" ]; then
  print_usage
elif [ "$1" = "install" ]; then
  install_avd
fi
