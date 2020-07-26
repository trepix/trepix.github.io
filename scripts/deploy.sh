#!/bin/sh

if [ "`git status -s`" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out master branch into public"
git worktree add -B master public origin/master

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
(cd themes/trepix && make build-assets)
make build

echo "Updating MASTER branch"
hash=`git log --pretty=format:'%h' -n 1`
cd public && git add --all && git commit -m "[${hash}] Automatic publish"

# echo "Pushing to github"
git push