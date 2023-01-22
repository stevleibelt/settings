#!/bin/bash
####

function _main () {
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  if [[ ! -f "~/.config/i3/config" ]];
  then
    /usr/bin/mkdir -p ~/.config/i3
    cp "${PATH_TO_THIS_SCRIPT}/bre14_config" ~/.config/i3/config

    echo ":: Please adapt content of file >>~/.config/i3/config<<."
  fi
}

_main ${@}

