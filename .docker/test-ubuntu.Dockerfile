# Dockerfile to test the installation script..

# Define image.
FROM ubuntu:jammy
# Set environment variables.
ENV DEBIAN_FRONTEND=noninteractive
# Create app directory.
WORKDIR /app
# Copy scripts.
COPY ./utils ./utils
COPY ./install.sh ./
COPY ./install-avd.sh ./
# Test installation.
RUN echo "Installing dependencies..." ; \
  apt-get update ; \
  apt-get upgrade -y --no-install-recommends ; \
  apt-get install -y --no-install-recommends apt-utils ; \
  apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl wget gnupg2 lsb-release sudo unzip ; \
  echo "Adding a sudoer..." ; \
  useradd -m test ; \
  usermod -aG sudo test ; \
  echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers ; \
  mkdir /home/test/Downloads ; \
  echo "Setting directory permissions..." ; \
  chown -R test:test /home/test ; \
  chown -R test:test /app
USER test
RUN export HOME=/home/test ; \
  bash ./install.sh

