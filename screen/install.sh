#!/bin/bash
####
# Installs screen settings if needed and possible
####
# @since: 2021-04-29
# @author: stev leibelt
####

function _install ()
{
    if [[ ! -f /usr/bin/screen ]];
    then
        echo ":: Screen is not installed."
        echo "   No file available in path >>/usr/bin/screen<<."
    fi

    local PATH_TO_THE_DESTINATION="~/.screenrc"

    if [[ -f "${PATH_TO_THE_DESTINATION}" ]];
    then
        echo ":: Screen configuration file exists."
        echo "   File available in path >>${PATH_TO_THE_DESTINATION}<<."
    else
        local PATH_OF_THE_CURRENT_SCRIPT_BASH=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)

        local PATH_TO_THE_SOURCE="${PATH_OF_THE_CURRENT_SCRIPT_BASH}/screenrc"

        ln -s "${PATH_TO_THE_SOURCE}" "${PATH_TO_THE_DESTINATION}"
    fi
}

_install
