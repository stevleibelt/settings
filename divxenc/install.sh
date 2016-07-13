#!/bin/bash
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2016-07-12
####

SOURCE_PATH=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd) 
DESTINATION_PATH=~/.divxenc

if [[ -d "$DESTINATION_PATH" ]]; then
    echo "already installed"
    echo "path exists: $DESTINATION_PATH"
    exit 1
fi

ln -s $SOURCE_PATH $DESTINATION_PATH
