#!/bin/bash
####

function _main () 
{
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  if [[ ! -d ~/.config ]];
  then
    echo "   creating ~/.config"
    /usr/bin/mkdir -p ~/.config/
  fi

  if [[ -f ~/.config/user-dirs.locale ]];
  then
    echo "   removing ~/config/user-dirs.locale"
    rm -fr ~/.config/user-dirs.locale
  fi

  if [[ -f ~/.config/user-dirs.dirs ]];
  then
    echo "   removing ~/config/user-dirs.dirs"
    rm -fr ~/.config/user-dirs.dirs
  fi

  ln -f -s "${PATH_TO_THIS_SCRIPT}/userDirs/user-dirs.locale" ~/.config/user-dirs.locale
  ln -f -s "${PATH_TO_THIS_SCRIPT}/userDirs/user-dirs.dirs" ~/.config/user-dirs.dirs

  xdg-settings set default-web-browser firefox.desktop
  xdg-settings set default-url-scheme-handler mailto thunderbird.desktop
  xdg-user-dirs-update
}

_main ${@}

