#!/bin/bash

ZSH_FILE=$HOME/.zshrc
BASH_FILE=$HOME/.bashrc

source_config() {
  if [[ -f "$ZSH_FILE" ]]; then
    source $ZSH_FILE
  else
    source $BASH_FILE
  fi
}

source_config