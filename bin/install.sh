#!/bin/bash
########
# @since 2019-05-29
# @author stev leibelt
# @todo
#   move into functions
########

function _main ()
{
  local LIST_OF_INSTALL_SCRIPTS
  local PATH_OF_THE_CURRENT_SCRIPT
  local PWD

  #begin of setup
  PATH_OF_THE_CURRENT_SCRIPT=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)
  PWD=$(pwd)

  cd "${PATH_OF_THE_CURRENT_SCRIPT}/../" || printf ":: Error\n   Could not change to directory >>%s<<" "${PATH_OF_CURRENT_INSTALL_SCRIPT}/../"
  git submodule init
  git submodule update
  cd "${PWD}" || printf ":: Error\n   Could not change to directory >>%s<<." "${PWD}"

  #ref: https://stackoverflow.com/questions/23356779/how-can-i-store-the-find-command-results-as-an-array-in-bash/54561526#54561526
  #mapfile -d '' LIST_OF_INSTALL_SCRIPTS < <(find "${PATH_OF_THE_CURRENT_SCRIPT}/../" -name install.sh -type f -exec realpath {} \;)
  mapfile -d '' LIST_OF_INSTALL_SCRIPTS < <(find "${PATH_OF_THE_CURRENT_SCRIPT}/../" -name install.sh -type f -not -path "${PATH_OF_THE_CURRENT_SCRIPT}" -print0)

  for PATH_OF_CURRENT_INSTALL_SCRIPT in "${LIST_OF_INSTALL_SCRIPTS[@]}";
  do
    read -r -p ">  Do you want to execute ${PATH_OF_CURRENT_INSTALL_SCRIPT:${#PATH_OF_THE_CURRENT_SCRIPT}}? (Y|n) "

    if [[ ${REPLY:-y} =~ ^[Yy]$ ]];
    then
      bash "${PATH_OF_CURRENT_INSTALL_SCRIPT}"
    fi
  done
}

_main "${@}"
