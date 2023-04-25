#!/bin/bash
# prints out all local branches status. won't change current branch

# exit on error
set -e
# print before execute
#set -x

current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "current branch: $current_branch"
echo "status:"
git status -s
echo "----------------------"
#exit 0

git for-each-ref --format="%(refname:short) %(upstream:short)" refs/heads | \
while read local remote
do
#echo $local
    if [ "$local" = "$current_branch" ] ; then
        #echo "curent branch, continue"
        continue
    fi
    git co $local
    echo "status:"
    git status -s
    echo "----------------------"
done

git co $current_branch

