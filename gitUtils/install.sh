#!/bin/bash

script_dir=$(dirname $0)

git_dir="./.git"

if [[ ! -d "$git_dir" ]]; then
    echo "$1 is not a git directory." >&2
    exit 1
fi

copy_hook() {
    local from="$script_dir/$1"
    local to="$git_dir/hooks/$2"
    touch $to
    echo "Copying $from to $to" >&2
    cp $from $to
    chmod +x $to
}

copy_hook jukwaa-pre-push pre-push

exit 0
