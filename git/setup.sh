#!/bin/bash
####
# Adds include path to this gitconfig
####
# @see: https://git-scm.com/docs/git-config
# @since: 2022-05-17
# @author: stev leibelt <artodeto@bazzline.net>
####

function _main () {
    local CURRENT_SCRIPT_PATH=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)
    local USER_GITCONFIG_FILE_PATH="${HOME}.gitconfig"

    if [[ -z ${WINDIR} ]];
    then
        #we are not on a git-on-windows machine
        local LINE_TO_ADD_TO_USER_GITCONFIG_FILE="    path = ${CURRENT_SCRIPT_PATH}/gitconfig"
    else
        #we are on a git-on-windows machine
        #we want to replace
        #   >>/c/Users/<username>/<<
        #with
        #   >>c:/Users/<username>/<<

        #contains something like >>c<<
        local CURRENT_DEVICE_CHARACTER="${CURRENT_SCRIPT_PATH:1:1}"
        local LINE_TO_ADD_TO_USER_GITCONFIG_FILE="    path = ${CURRENT_DEVICE_CHARACTER}:${CURRENT_SCRIPT_PATH:2}/gitconfig"
    fi

    if [[ ! -f "${USER_GITCONFIG_FILE_PATH}" ]];
    then
        echo ":: File >>${USER_GITCONFIG_FILE_PATH}<< does not exist. Creating it."

        touch "${USER_GITCONFIG_FILE_PATH}"
    fi

    if cat "${USER_GITCONFIG_FILE_PATH}" | grep --quiet '\[include\]';
    then
        echo ":: There is already a section >>[include]<< defined in >>${USER_GITCONFIG_FILE_PATH}<<."
        echo "   Please add the following line on your own."
        echo ""
        echo "${LINE_TO_ADD_TO_USER_GITCONFIG_FILE}"
    else
        echo "[include]" >> "${USER_GITCONFIG_FILE_PATH}"
        echo "${LINE_TO_ADD_TO_USER_GITCONFIG_FILE}" >> "${USER_GITCONFIG_FILE_PATH}"
    fi
}

_main
