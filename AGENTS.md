# AGENTS.md — dotfiles

This repo is a live Arch/X11 (i3) dotfiles setup, not an application. There is
no package manifest, build step, or test suite. The tracked files are the source
of truth; `$HOME` mirrors them through absolute symlinks.

Full environment notes already live in `~/AGENTS.md` (cursor theme, i3 socket,
commit rules). This file covers what is specific to the repo.

## Edit in the repo, never in `$HOME`

- `~/.config` is a real directory. Only selected apps are symlinked to
  `~/dotfiles/.config/<app>`: `i3`, `polybar`, `picom`, `kitty`, `nvim`, `rofi`,
  `mpd`, `ncmpcpp`, `autorandr`, `pulse`, `redshift`, `eww`, `gtk-3.0`.
- Home files symlinked individually: `.zshrc`, `.zprofile`, `.xprofile`,
  `.Xresources`, `.icons`, `.scripts`, `.tmux`, `.tmux.conf`, `.oh-my-zsh`.
- To add a config: create it under the same relative path in this repo, move any
  existing real file out of `$HOME`, then
  `ln -sfn /home/rjeffvalle/dotfiles/<path> ~/<path>`. Use absolute targets.
- `~/.zshrc` is currently a real file, not a symlink, despite
  `sync/setup_config.js` expecting one. Check `readlink -f ~/.zshrc` before
  assuming edits to this repo take effect.
- External paths referenced but not tracked: `~/.zsh_private` (secrets sourced
  by `.zshrc`), `~/.wallpapers/selected.*` (i3 `feh` background), and
  `~/Apps/Handy.AppImage`. Do not commit or create substitutes.

## Applying changes

- i3: validate with `i3 -C -c ~/.config/i3/config`, then `i3-msg reload`.
  Use `i3-msg restart` when changing `exec_always` lines (cursor, display setup,
  wallpaper, polybar). If `i3-msg` cannot find the socket:
  `I3SOCK=/run/user/1000/i3/ipc-socket.$(pgrep -x i3) i3-msg restart`.
- Polybar: `~/.config/polybar/launch.sh` (kills all bars, then starts one bar per
  monitor). It exports `POLYBAR_COLOR_*` from `[colors]`, so color edits require
  relaunching, not just `polybar-msg`.
- Eww: `eww reload` after changing `.yuck`/`.scss`; `eww open <window>` to show.
  Bluetooth widgets shell out to `bluetoothctl`; history widgets need
  `dunstctl` + `jq`.
- Kitty: `.scripts/ktheme.sh` picks a theme and rewrites `theme.conf` as an
  absolute symlink; `kitty.conf` includes `./theme.conf`. Only
  `Rjeffvalle*.conf` themes are tracked.
- Neovim: lazy.nvim bootstraps itself on first start; `lazy-lock.json` is
  committed, plugin sources are not.
- `system/etc/*` mirrors real `/etc` files (sysctl, TLP, NVIDIA/optimus). Nothing
  deploys them automatically; copy with `sudo` and reload the relevant service.

## `sync/` is bootstrap tooling — not for normal edits
> [!WARNING]
> The syncthing process is not up to date, do not use it for anything or make modifications to it until it is updated.

`./sync.sh` installs `PACKAGES` from `sync/constants.js` with `sudo pacman -S`,
wipes and recreates `backup/`, moves real `~/.config/<app>` dirs, `~/.scripts` and
home files into `backup/`, then creates symlinks, sets the `es` X11 keymap, changes
the shell to zsh, and uses nvm + Node 16. It is destructive and needs network,
sudo, and Node. Do not run it to "apply" a config edit; use `ln -sfn` / reloads.

Known defect: `sync/constants.js` is missing a comma after
`"zsh-autosuggestions"`, so `node --check sync/constants.js` fails and `sync.sh`
currently cannot run. Fix it before relying on sync.

## Verification available

- Shell: `bash -n <script>` (or `sh -n`).
- JS: `node --check <file>`.
- Lua: `luac -p <file>`, or `nvim --headless "+Lazy! sync" +qa` for plugins.
- i3 config: `i3 -C -c .config/i3/config`.
- There are no unit/integration tests or CI workflows.

## Conventions and git hygiene

- Commits use Conventional Commits, always in English, imperative, lowercase
  subject (e.g. `feat(eww): create notification center`).
- The worktree often contains unrelated user changes (eww, i3, `.scripts/*`).
  Do not revert or clean them without asking.
- `backup/`, `.oh-my-zsh/*` (except `custom/global.zsh` and `custom/dev.zsh`),
  most tmux plugins (only the `tpm` submodule is tracked), `tmux/resurrect`, and
  non-`Rjeffvalle*` kitty themes are gitignored.
- Cursor theme is centralized across five files (i3 variables, `.xprofile`,
  `.Xresources`, `gtk-3.0/settings.ini`, `.icons/default/index.theme`); change
  them together. Details in `~/AGENTS.md` §2.
