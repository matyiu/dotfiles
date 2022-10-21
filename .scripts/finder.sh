#!/usr/bin/env bash

if [ ! -z "$@" ]; then
	coproc ( exo-open "$@" > /dev/null 2>&1 )
else
	fd -H --full-path $HOME
fi
