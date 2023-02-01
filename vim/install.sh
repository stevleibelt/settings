#!/bin/bash
####

function _main () {
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  ln -f -s "${PATH_TO_THIS_SCRIPT}/.vim" ~/.vim
  ln -f -s "${PATH_TO_THIS_SCRIPT}/.vimrc" ~/.vimrc

  echo ":: You have to call >>updateVimBuindesAndPluginsWithVundle<< on your own."
}

_main ${@}

