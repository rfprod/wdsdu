#!/usr/bin/env bash

# shellcheck source=utils/colors.sh
source utils/colors.sh ''

on_error() {
  local EXIT_CODE
  EXIT_CODE=$?
  local LINE
  LINE=${BASH_LINENO[0]:-unknown}
  local COMMAND
  COMMAND=${BASH_COMMAND:-unknown}

  printf '\n%sError on LINE %s: exit code %s\nCommand: %s%s\n' \
    "$RED" "$LINE" "$EXIT_CODE" "$COMMAND" "$DEFAULT" >&2

  exit "$EXIT_CODE"
}

install_error_handler() {
  set -Eeuo pipefail

  trap on_error ERR
  trap 'exit 130' INT
  trap 'exit 143' TERM
}
