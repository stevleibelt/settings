#!/bin/bash
####
# @since: 2025-01-20
# @author: stev leibelt <artodeto@bazzline.net>
####

function _main() {
  local CURRENT_SCRIPT_PATH
  local SOURCE_FILE_NAME
  local SOURCE_FILE_PATH
  local TARGET_DIRECTORY_PATH
  local TARGET_FILE_PATH

  CURRENT_SCRIPT_PATH=$(dirname $(realpath "${0}"))
  SOURCE_FILE_NAME="${1}"
  TARGET_DIRECTORY_PATH="${2}"

  SOURCE_FILE_PATH="${CURRENT_SCRIPT_PATH}/${SOURCE_FILE_NAME}"
  TARGET_FILE_PATH="${TARGET_DIRECTORY_PATH}/${SOURCE_FILE_NAME}"

  if [[ -f "${TARGET_FILE_PATH}" ]];
  then
    mv "${TARGET_FILE_PATH}" "${TARGET_FILE_PATH}.bak"
  fi

  if [[ ! -d "${TARGET_DIRECTORY_PATH}" ]];
  then
    mkdir -p "${TARGET_DIRECTORY_PATH}"
  fi

  ln -s "${SOURCE_FILE_PATH}" "${TARGET_FILE_PATH}"
}

_main "config" "${HOME}/.config/ghostty"
