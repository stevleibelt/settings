# settings

settings and dot files

# install

* symlink directories or files where needed

# todo

* create an installer or updater (remove all softlinks to <path> and recall installer)

```
# git
ln -s <path>/git/gitconfig $HOME/.gitconfig
ln -s <path>/git/gitignore.global $HOME/.gitignore.global

# i3
ln -s <path>/i3 $HOME/.i3
# list available *.conf
ln -s <path>/<conf>.conf $HOME/.i3status.conf
```
