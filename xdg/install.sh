#!/bin/bash
####

function _main () 
{
  local PATH_TO_THIS_SCRIPT

  PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  if [[ ! -d "${HOME}/.config" ]];
  then
    echo "   creating >>${HOME}/.config<<"
    /usr/bin/mkdir -p "${HOME}/.config"
  fi

  if [[ -f "${HOME}/.config/user-dirs.locale" ]];
  then
    echo "   removing ${HOME}/config/user-dirs.locale"
    rm -fr "${HOME}/.config/user-dirs.locale"
  fi

  if [[ -f "${HOME}/.config/user-dirs.dirs" ]];
  then
    echo "   removing ${HOME}/config/user-dirs.dirs"
    rm -fr "${HOME}/.config/user-dirs.dirs"
  fi

  ln -f -s "${PATH_TO_THIS_SCRIPT}/userDirs/user-dirs.locale" "${HOME}/.config/user-dirs.locale"
  ln -f -s "${PATH_TO_THIS_SCRIPT}/userDirs/user-dirs.dirs" "{HOME}/.config/user-dirs.dirs"

  xdg-settings set default-web-browser firefox.desktop
  xdg-settings set default-url-scheme-handler mailto thunderbird.desktop
  xdg-user-dirs-update
}

_main "${@}"

