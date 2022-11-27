#!/bin/sh

is_repo=$(git rev-parse --is-inside-work-tree 2> /dev/null)

if [[ $is_repo && $is_repo == true ]]; then
	if  [ $1 == "curr_branch" ]; then
		echo "($(git branch --show-current))"
	fi
fi
