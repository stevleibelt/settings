#!/bin/bash
####

function _main () {
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  if [[ ! -f "~/.config/i3status/config" ]];
  then
    /usr/bin/mkdir -p ~/.config/i3status
    cp "${PATH_TO_THIS_SCRIPT}/bre14_config" ~/.config/i3status/config

    echo ":: Please adapt content of file >>~/.config/i3status/config<<."
  fi
}

_main ${@}

