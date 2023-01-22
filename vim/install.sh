#!/bin/bash
####

function _main () {
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  ln -s "${PATH_TO_THIS_SCRIPT}/vim" ~/.vim
  ln -s "${PATH_TO_THIS_SCRIPT}/.vimrc" ~/.vimrc

  updateVimBundlesAndPluginsWithVundle
}

_main ${@}

