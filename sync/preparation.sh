#!/bin/bash

# Update the system and install wget
sudo pacman -Syu wget

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

. ./sync/utils/set_nvm_path.sh

nvm install 16.19.0
nvm alias default 16.19.0
