#!/bin/bash
####

function _main ()
{
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  if [[ ! -f "${HOME}/.config/i3/config" ]];
  then
    /usr/bin/mkdir -p ~/.config/i3
    cp "${PATH_TO_THIS_SCRIPT}/bre14_config" "${HOME}/.config/i3/config"

    echo ":: Please adapt content of file >>${HOME}/.config/i3/config<<."
  fi

  if [[ -f "${HOME}/.xinitrc" ]];
  then
    echo ":: File exists."
    echo "   Moving >>${HOME}/.xinitrc<< to >>${HOME}/.xinitrc.tmp<<"
    mv "${HOME}/.xinitrc" "${HOME}/.xinitrc.tmp"

    cp "${PATH_TO_THIS_SCRIPT}/xinitrc" "${HOME}/.xinitrc"

    echo "   You have to merge both files manually."
    vimdiff "${HOME}/.xinitrc.tmp" "${HOME}/.xinitrc"

    echo "   Please remove this file by hand >>${HOME}/.xinitrc.tmp<<"
  else
    cp "${PATH_TO_THIS_SCRIPT}/xinitrc" "${HOME}/.xinitrc"
  fi

}

_main ${@}

