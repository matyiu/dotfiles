# Dotfiles
## Requirements
### Kitty Themes
To use the ```ktheme``` script you will have to install the following packages:
- fzf

## How to install themes for Kitty terminal emulator
To install themes for Kitty you will need to create a folder called "kitty-themes" inside the ```.config/kitty``` folder. Thn place the theme inside the kitty-themes folder and if you use the ```ktheme.sh``` script a fzf screen will be shown to select the theme you want.

This selection will be saved permanently creating a symbolic link (called theme.conf) inside the kitty config folder that will point to the theme you've selected.

## Debugging
### EWW
Running `eww logs` will continuously print the logs of eww to the terminal. To stop it, you must press `Ctrl+C`.

After applying changes to the eww config, you must reload the config by running `eww reload`. This command will also print any errors that may have occurred.
