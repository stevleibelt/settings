#!/bin/bash
####

function _main () {
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  /usr/bin/mkdir -p ~/.config/i3
  cp "${PATH_TO_THIS_SCRIPT}/bre14_config" ~/.config/i3/config

  echo ":: Please adapt content of file >>~/.config/i3/config<<."
}

_main ${@}

