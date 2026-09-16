#!/bin/bash

confirm() {
  local PROMPT
  PROMPT=${1:-"Continue?"}
  local DEFAULT_ANSWER
  DEFAULT_ANSWER=${2:-yes}
  local USER_INPUT_TIMEOUT
  USER_INPUT_TIMEOUT=${3:-6}
  local ANSWER
  ANSWER=""
  local REMAINING
  local CHOICES

  case ${DEFAULT_ANSWER,,} in
    yes|y)
      DEFAULT_ANSWER=yes
      CHOICES='[Y/n]'
      ;;
    no|n)
      DEFAULT_ANSWER=no
      CHOICES='[y/N]'
      ;;
    *)
      printf 'Invalid DEFAULT_ANSWER: %s\n' "$DEFAULT_ANSWER" >&2
      return 2
      ;;
  esac

  # Non-interactive mode
  if [[ ! -t 0 ]]; then
    if [[ $DEFAULT_ANSWER == yes ]]; then
      printf 'y'
    else
      printf 'n'
    fi
    return
  fi

  # Interactive mode
  for ((REMAINING = USER_INPUT_TIMEOUT; REMAINING > 0; REMAINING--)); do
    printf '\r\033[K%s %s (%ss): ' "$PROMPT" "$CHOICES" "$REMAINING" >&2

    if IFS= read -r -n 1 -t 1 ANSWER; then
      # Pressing Enter selects the DEFAULT_ANSWER
      if [[ -z $ANSWER ]]; then
        [[ $DEFAULT_ANSWER == yes ]] && ANSWER=y || ANSWER=n
      fi

      printf '\r\033[K%s %s: %s\n' "$PROMPT" "$CHOICES" "$REMAINING" >&2

      # stdout contains only the ANSWER
      printf '%s' "$ANSWER"
      return
    fi
  done

  # Timeout selects the DEFAULT_ANSWER
  [[ $DEFAULT_ANSWER == yes ]] && ANSWER=y || ANSWER=n

  printf '\r\033[K%s %s (time out): %s\n' "$PROMPT" "$CHOICES" "$REMAINING" >&2
  printf '%s' "$ANSWER"
}
