ZSH_FILE=$HOME/.zshrc
BASH_FILE=$HOME/.bashrc

NVM_DIR_INSTALL='export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'

if [[ -f "$ZSH_FILE" ]]; then
  echo "$NVM_DIR_INSTALL" >> "$ZSH_FILE"
  source $ZSH_FILE
else
  echo "$NVM_DIR_INSTALL" >> "$BASH_FILE"
  source $BASH_FILE
fi
