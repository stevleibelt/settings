#!/bin/bash
########
# @since 2019-05-29
# @author stev leibelt
# @todo
#   move into functions
########

clear

#begin of setup
DATETIME=$(date +%y%m%d_+%T)
PATH_OF_THE_CURRENT_SCRIPT=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)

echo "${PATH_OF_THE_CURRENT_SCRIPT}"

#bo gitconfig
echo ":: Do you want to setup gitconfig? (y|n - default is y)"
read YES_OR_NO

if [[ ${YES_OR_NO} != "n" ]];
then
    if [[ -f ~/.gitconfig  ]]
    then
        echo "   Renaming ~/.gitconfig to ~/.gitconfig.${DATETIME}"
        mv ~/.gitconfig ~/.gitconfig.${DATETIME}
    fi

    echo "   Creating softlink for ~/.gitconfig"
    ln -s ${PATH_OF_THE_CURRENT_SCRIPT}/git/gitconfig ~/.gitconfig
fi
#eo gitconfig

#bo gitignore.global
echo ":: Do you want to setup gitignore.global? (y|n - default is y)"
read YES_OR_NO

if [[ ${YES_OR_NO} != "n" ]];
then
    if [[ -f ~/.gitignore.global  ]]
    then
        echo "   Renaming ~/.gitignore.global to ~/.gitignore.global.${DATETIME}"
        mv ~/.gitignore.global ~/.gitignore.global.${DATETIME}
    fi

    echo "   Creating softlink for ~/.gitignore.global"
    ln -s ${PATH_OF_THE_CURRENT_SCRIPT}/git/gitignore.global ~/.gitignore.global
fi
#eo gitconfig

#bo i3
echo ":: Do you want to setup i3? (y|n - default is y)"
read YES_OR_NO

if [[ ${YES_OR_NO} != "n" ]];
then
    if [[ -d ~/.config/i3  ]]
    then
        echo "   Renaming ~/.config/i3 to ~/.config/i3.${DATETIME}"
        mv ~/.config/i3 ~/.config/i3.${DATETIME}
    fi

    echo "   Creating softlink for ~/.config/i3"
    ln -s ${PATH_OF_THE_CURRENT_SCRIPT}/i3 ~/.conifg/i3

    if [[ -f .config/i3status/config ]]
    then
        echo "   Renaming ~/.config/i3status/config to ~/.config/i3status/config.${DATETIME}"
        mv ~/.config/i3status/config ~/.config/i3status/config.${DATETIME}

        echo "   Creating new one from example configuration. You have to adapt it!"
        cp ${PATH_OF_THE_CURRENT_SCRIPT}/i3/exampleStatus.conf ~/.config/i3status/config
    fi
fi
#eo i3

#bo .Xresources
echo ":: Do you want to setup .Xresources? (y|n - default is y)"
read YES_OR_NO

if [[ ${YES_OR_NO} != "n" ]];
then
    if [[ -f ~/.Xresources  ]]
    then
        echo "   Renaming ~/.Xresources to ~/.Xresources.${DATETIME}"
        mv ~/.Xresources ~/.Xresources.${DATETIME}
    fi

    echo "   Creating softlink for ~/.Xresources"
    ln -s ${PATH_OF_THE_CURRENT_SCRIPT}/.Xresources ~/.Xresources
fi
#eo .Xressource

#bo .vim
echo ":: Do you want to setup .vim and .vimrc? (y|n - default is y)"
read YES_OR_NO

if [[ ${YES_OR_NO} != "n" ]];
then
    if [[ -f ~/.vimrc  ]]
    then
        echo "   Renaming ~/.vimrc to ~/.vimrc.${DATETIME}"
        mv ~/.vimrc ~/.vimrc.${DATETIME}
    fi

    echo "   Creating softlink for ~/.vimrc"
    ln -s ${PATH_OF_THE_CURRENT_SCRIPT}/vim/.vimrc ~/.vimrc

    if [[ -d ~/.vim ]];
    then
        echo "   Renaming ~/.vim to ~/.vim.${DATETIME}"
        mv ~/.vim ~/.vim.${DATETIME}
    fi

    echo "   Creating softlink for ~/.vim"
    ln -s ${PATH_OF_THE_CURRENT_SCRIPT}/vim/.vim ~/.vim
fi
#eo .Xressource

