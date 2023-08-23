# Dotfiles

I set up these dotfiles to be able to automatically configure a new PC quickly and easily. This current iteration of them is managed via [chezmoi](https://www.chezmoi.io).
As of this time, only macOS is supported as an installation option. Other installs may work partially or not at all.

## Getting started

To get started, simply run:

```
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Azzapop
```

This will install chezmoi and then download and configure the dotfiles themselves.

## Install process

1. Chezmoi will create a config file, prompting you for information
2. All folders and files from the `src/` directory are applied from chezmoi to the home directory. Any template files will be generated using data provided in the config.
3. Chezmoi will then run any scripts in `src/.chezmoiscripts` in alphabetical order, see [chezmoi scripts](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/) for more info.
4. Set up non-dotfiles (mostly anything not in the chezmoi source directory)
    1. Move any fonts to the fontbook
    2. Symlink wallpapers to the Pictures folders
5. Run the post-install script to manage any extra downloads or setup that might be needed
    1. Install Xcode tools
    2. Install brew
        1. Install CLI apps
        2. Install casks
    3. Install [antidote](https://github.com/mattmc3/antidote)
    4. Install NVM
        1. Install latest node version
        2. Install typescript language server globally
        3. Install jjson globally

### Manual setup

Once installed, there are some manual things that you will need to do to finish the setup.

- [ ] Configure laptop setup: wallpaper, user settings, log in to app store
- [ ] Configure browser setup: default browser, login to firefox, setup plugins (1password, adblocker)
- [ ] Generate an ssh key and upload it to github


## Caveats

It is difficult to programatically configure some apps, these are some of the inconsitencies to be aware of on a fresh install.

### iTerm2

When first opening iTerm2, it will prompt you to download the python runtime required. Accepting this will allow it to run the setup python script to enable the correct default profile. Because this happens only when opening for the first time, any shells that are started will not be running the correct profile until the python runtime has been sucessfully installed.
