#!/bin/bash

ZSH_FILE=$HOME/.zshrc

source_config() {
  if [[ -f "$ZSH_FILE" ]]; then
    source "$HOME"/.zshrc
  else
    source "$HOME"/.bashrc
  fi
}

source_config