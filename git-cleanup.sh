#!/bin/sh

# refer to https://stackoverflow.com/questions/1904860/how-to-remove-unreferenced-blobs-from-my-git-repo
git remote rm origin || true
cd .git
rm -rf refs/remotes/ refs/original/ *_HEAD logs/
git for-each-ref --format="%(refname)" refs/original/ | xargs git update-ref -d
git -c gc.reflogExpire=0 -c gc.reflogExpireUnreachable=0 -c gc.rerereresolved=0 -c gc.rerereunresolved=0 -c gc.pruneExpire=now gc "$@"
