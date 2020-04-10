#!/usr/bin/env bash

PROGNAME=$(basename "$0")

usage() {
    echo "split a subfolder out into a new git repository"
    echo "usage: $PROGNAME <repo url> <subfolder>"
    echo "to import the new standalone repo as a subdirectory of an existing git repo:"
    echo "git subtree add --prefix=<subdirectory> <src repo> <target branch>"
    return
}

if [ "$#" -ne 2 ]; then
    usage
    exit 1
fi

TEMPDIR=$(mktemp -d /tmp/git-XXXXX)
# folder within your project that you'd like to create a separate repository from
SUBFOLDER=$2
# target branch of your project
BRANCH='master'

# checkout the target repo
if ! git clone $1 $TEMPDIR ; then
    echo "failed to clone the target repo from $1"
    exit 1
fi

cd $TEMPDIR
# filter the specified branch in your directory and remove empty commits
git filter-branch --prune-empty --subdirectory-filter $SUBFOLDER $BRANCH
# make .git smaller
git gc --aggressive --prune=now
echo "done. Check $TEMPDIR"
