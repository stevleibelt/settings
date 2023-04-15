#!/bin/bash
####

function _main ()
{
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  if [[ ! -f "${HOME}/.config/mimeapps.list" ]];
  then
    /usr/bin/mkdir -p ~/.config
    cp "${PATH_TO_THIS_SCRIPT}/mimeapps.list" "${HOME}/.config/"

    echo ":: Please adapt content of file >>${HOME}/.config/mimeapps.list<<."
  else
    echo ":: File >>${HOME}/.config/mimeapps.list<< exists already"
    echo "   No changes where made"
  fi
}

_main ${@}

