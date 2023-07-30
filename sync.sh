#!/bin/bash

echo 'Preparing node and nvm...'
. ./sync/preparation.sh

echo 'Start syncing...'
./sync/sync.js

