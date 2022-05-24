#!/bin/sh
KITTY_THEME_PATH="$HOME/.config/kitty/kitty-themes"
KITTY_DIR_PATH="$HOME/.config/kitty"

preview_command="head -n 40 {} && kitty @ --to $KITTY_LISTEN_ON set-colors -a -c {}"

theme="$(ls "$KITTY_THEME_PATH"/*.conf | fzf --prompt "Select a Theme: " --preview "$preview_command")"

ln -sfn $theme "$KITTY_DIR_PATH/theme.conf"
