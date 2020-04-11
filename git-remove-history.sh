#!/usr/bin/env bash

PROGNAME=$(basename "$0")

usage() {
    echo "remove history of file/directory from a git repo"
    echo "usage: $PROGNAME <repo> <target file/directory>"
}

if [ "$#" -ne 2 ]; then
    usage
    exit 1
fi

if ! [ -d $1 ]; then
    echo "repo $1 does not exist"
    exit 1
fi

# overwrite the history
echo "start overwriting the history..."
cd $1 && git filter-branch -f --index-filter "git rm -rf --cached --ignore-unmatch $2" --prune-empty --tag-name-filter cat -- --all

echo "start garbage collection..."
git for-each-ref --format="delete %(refname)" refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --aggressive --prune=now

