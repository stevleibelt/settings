#!/bin/bash

rm ~/.config/btop/btop.conf

if [[ ! -d ~/.config/btop ]];
then
  mkdir -p ~/.config/btop
fi

ln -s ~/software/source/com/github/stevleibelt/settings/btop/btop.conf ~/.config/btop/
