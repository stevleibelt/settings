# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Open]

### To Add

* create a `setup.sh` file for each first level sub directory
    * it should take the following arguments: `install`, `uninstall` and `status`
    * `install` -> install the setting
    * `status` -> show current state (installed or not)
    * `uninstall` -> uninstall the setting
* create an installer or updater (remove all softlinks to <path> and recall installer)
    * check each first level sub directory if it contains a "setup.sh"
    * if exists, ask user if it should be installed and call it with "setup.sh install"

### To Change

## [Unreleased]

### Added

* Added this changelog
* Added `git/setup.sh`
* Added `merge-and-squash` as git alias

### Changed

* Commented out `[user]` section in `git/config` since this base config should be included now
* Moved not maintained `install.sh` into [bin](bin/)
