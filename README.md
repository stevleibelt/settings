# Settings

This repository contains my settings and dot files.

The current change log can be found [here](CHANGELOG.md).

# Install

* symlink directories or files where needed

```
# git
ln -s <path>/git/gitconfig $HOME/.gitconfig
ln -s <path>/git/gitignore.global $HOME/.gitignore.global

# i3
ln -s <path>/i3 $HOME/.config/i3
# list available *.conf
ln -s <path>/<conf>.conf $HOME/.config/i3status/config

# abcde
ln -s <path>/abcde/.abcde.conf $HOME/.abcde.conf

# gnome-terminal-colors

git submodule init
git submodule update
bash ./gnome-terminal-colors/install.sh
# 66 - color schema
# 1 - use dir colors
```
