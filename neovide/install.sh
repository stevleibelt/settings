#!/bin/bash
####

function _main () {
  local PATH_TO_THIS_SCRIPT=$(cd $(dirname "${0}"); pwd)

  ln -f -s "${PATH_TO_THIS_SCRIPT}/nvim" ~/.config/nvim
  ln -f -s "${PATH_TO_THIS_SCRIPT}/init.vim" ~/.config/nvim/init.vim

  echo ":: You have to call >>updateVimBuindesAndPluginsWithVundle<< on your own."
}

_main "${@}"

