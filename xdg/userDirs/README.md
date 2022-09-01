# Default applications and paths

## Howto setup


### Setup the paths

```bash
sudo pacman -S xdg-user-dirs
cd ~/.config
rm -fr user-dirs.locale
rm -fr user-dirs.dir
ln -s <path to this directory> user-dirs.locale
ln -s <path to this directory> user-dirs.dir
```

### Setup the applications

```bash
#xdg-settings is used to set a single application for a varity of MIME types
xdg-settings set default-web-browser firefox.desktop
xdg-settings set default-url-scheme-handler mailto thunderbird.desktop

#xdg-mime is used to set the handling for a single MIME type
##set a default
xdg-mime default feh.desktop image/jpeg
##get a default
xdg-mime query default image/jpeg
```

## Optional

```
# Create default directories
xdg-user-dirs-update
```

## Links

* [Default Applications](https://wiki.archlinux.org/title/Default_applications) - 20220901
* [xdg-utils](https://wiki.archlinux.org/title/Xdg-utils)
* https://wiki.archlinux.org/index.php/Xdg_user_directories

