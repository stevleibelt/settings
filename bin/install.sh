#!/bin/bash
########
# @since 2019-05-29
# @author stev leibelt
# @todo
#   move into functions
########

function _main ()
{
  local DATETIME
  local LIST_OF_INSTALL_SCRIPTS
  local PATH_OF_THE_CURRENT_SCRIPT

  #begin of setup
  DATETIME=$(date +%y%m%d_+%T)
  PATH_OF_THE_CURRENT_SCRIPT=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)

  #ref: https://stackoverflow.com/questions/23356779/how-can-i-store-the-find-command-results-as-an-array-in-bash/54561526#54561526
  #mapfile -d '' LIST_OF_INSTALL_SCRIPTS < <(find "${PATH_OF_THE_CURRENT_SCRIPT}/../" -name install.sh -type f -exec realpath {} \;)
  mapfile -d '' LIST_OF_INSTALL_SCRIPTS < <(find "${PATH_OF_THE_CURRENT_SCRIPT}/../" -name install.sh -type f -not -path "${PATH_OF_THE_CURRENT_SCRIPT}" -print0)

  for PATH_OF_CURRENT_INSTALL_SCRIPT in "${LIST_OF_INSTALL_SCRIPTS[@]}";
  do
    read -p ">  Do you want to execute ${PATH_OF_CURRENT_INSTALL_SCRIPT:${#PATH_OF_THE_CURRENT_SCRIPT}}? (Y|n) "

    if [[ ${REPLY:-y} =~ ^[Yy]$ ]];
    then
      bash "${PATH_OF_CURRENT_INSTALL_SCRIPT}"
    fi
  done
}

_main "${@}"
