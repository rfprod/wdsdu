#!/bin/bash

require_command() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  }
}

require_debian_family() {
  [[ -r /etc/os-release ]] || {
    echo "Cannot identify the operating system" >&2
    exit 1
  }

  # shellcheck disable=SC1091
  source /etc/os-release

  case "${ID:-}" in
    ubuntu|debian|linuxmint|pop)
      ;;
    *)
      printf 'Unsupported distribution: %s\n' "${PRETTY_NAME:-unknown}" >&2
      exit 1
      ;;
  esac
}

require_debian_family

require_command apt
require_command sudo
