#!/bin/sh
#
# Based on http://git-scm.com/book/en/Git-and-Other-Systems-Migrating-to-Git

path=/tmp/imported-shallow
cd $path

# Configure and fetch a new SVN remote that contains all history.
remote='svn-deep'

url=`git config --get svn-remote.svn.url`
fetch=`git config --get svn-remote.svn.fetch | sed "s|remotes/|remotes/$remote/|g"`
branches=`git config --get svn-remote.svn.branches | sed "s|remotes/|remotes/$remote/|g"`
tags=`git config --get svn-remote.svn.tags | sed "s|remotes/|remotes/$remote/|g"`

git config svn-remote.$remote.url $url
git config svn-remote.$remote.fetch $fetch
git config svn-remote.$remote.branches $branches
git config svn-remote.$remote.tags $tags

git svn fetch --svn-remote $remote

# Transplant the work done locally to the new branches we got from $remote.
git for-each-ref refs/heads |
  cut -d / -f 3- |
  env GREP_OPTIONS='' grep -v @ |
  while read branch_name; do
    remote_branch_name=$branch_name
    if [ "$branch_name" == "master" ]; then
      remote_branch_name=trunk
    fi

    echo "Transplanting work done on $branch_name to be based off of $remote/$remote_branch_name"

    first_local_commit=`git log --format=%H $remote_branch_name..$branch_name | tail -1`

    # Transplant local commits to the SVN branch containing the whole history.
    git rebase --onto $remote/$remote_branch_name $first_local_commit~1 master
  done
