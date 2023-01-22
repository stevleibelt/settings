#!/bin/bash
####

function _main () {
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  for CURRENT_EXTENSION_LINE in $(cat "${PATH_TO_THIS_SCRIPT}/my_extension_list.txt");
  do
    #we trigger an update of an existing extension by using >>--force<<
    vscodium --force --install-extension "${CURRENT_EXTENSION_LINE}"
  done
}

_main ${@}

