const PACKAGES = [
    "i3-wm",
    "rofi",
    "autorandr",
    "ncmpcpp",
    "mpv",
    "mpd",
    "kitty",
    "picom",
    "polybar",
    "ranger",
    "redshift",
    "pipewire",
    "pipewire-pulse",
    "wireplumber",
    "neovim",
    "fd",
    "zsh",
    "tmux",
]

const DIRECTORIES = [
    'i3',
    'rofi',
    'autorandr',
    'ncmpcpp',
    'mpv',
    'mpd',
    'kitty',
    'picom',
    'polybar',
    'pulse',
    'ranger',
    'redshift'
]

const HOME = process.env.HOME

const CONFIG_DIR = HOME + '/.config'

const SCRIPTS_DIR = HOME + '/.scripts'

const DOTFILES_DIR = HOME + '/dotfiles'

const BACKUP_DIR = DOTFILES_DIR + '/backup'

module.exports = {
    PACKAGES,
    DIRECTORIES,
    HOME,
    CONFIG_DIR,
    SCRIPTS_DIR,
    BACKUP_DIR,
    DOTFILES_DIR,
}