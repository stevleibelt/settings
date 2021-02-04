# settings

settings and dot files

# install

* symlink directories or files where needed

# todo

* create a `setup.sh` file for each first level sub directory
    * it should take the following arguments: `install`, `uninstall` and `status`
    * `install` -> install the setting
    * `status` -> show current state (installed or not)
    * `uninstall` -> uninstall the setting
* create an installer or updater (remove all softlinks to <path> and recall installer)
    * check each first level sub directory if it contains a "setup.sh"
    * if exists, ask user if it should be installed and call it with "setup.sh install"

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
```
