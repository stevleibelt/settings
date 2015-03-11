# howto

```
sudo pacman -S xdg-user-dirs
cd ~/.config
rm -fr user-dirs.locale
rm -fr user-dirs.dir
ln -s <path to this directory> user-dirs.locale
ln -s <path to this directory> user-dirs.dir
```

## optional

```
# generate dirs by using the configuration
xdg-user-dirs-update
```

# links

* https://wiki.archlinux.org/index.php/Xdg_user_directories
