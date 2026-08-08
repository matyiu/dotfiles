export WLR_NO_HARDWARE_CURSORS=1

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi


# Added by Antigravity CLI installer
export PATH="/home/rjeffvalle/.local/bin:$PATH"
