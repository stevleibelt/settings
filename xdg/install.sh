#!/bin/bash
####

function _main () {
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  /usr/bin/mkdir -p ~/.config/
  rm -fr ~/.config/user-dirs.locale
  rm -fr ~/.config/user-dirs.dirs
  ln -f -s "${PATH_TO_THIS_SCRIPT}/userDirs/user-dirs.locale ~/.config/user-dirs.locale"
  ln -f -s "${PATH_TO_THIS_SCRIPT}/userDirs/user-dirs.dirs ~/.config/user-dirs.dirs"

  xdg-settings set default-web-browser firefox.desktop
  xdg-settings set default-url-scheme-handler mailto thunderbird.desktop
  xdg-user-dirs-update
}

_main ${@}

