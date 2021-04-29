#!/bin/bash
####
# Uninstalls screen settings if needed and possible
####
# @since: 2021-04-29
# @author: stev leibelt
####

function _uninstall ()
{
    local PATH_TO_THE_SOURCE="~/.screenrc"

    if [[ -f ${PATH_TO_THE_SOURCE} ]];
    then
        rm "${PATH_TO_THE_SOURCE}"
    else
        echo ":: No screen configuration file exists."
        echo "   File not available in path >>${PATH_TO_THE_SOURCE}<<."
    fi
}

_uninstall
