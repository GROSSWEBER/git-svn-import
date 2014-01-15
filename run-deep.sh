#!/bin/sh
#
# Based on http://git-scm.com/book/en/Git-and-Other-Systems-Migrating-to-Git

path=/tmp/imported
rm -rf $path

# The (no author) line in users.txt needs to be there because the first commit is done by the Google Code system
# It requires an email address, otherwise git would refuse to use it.
git svn clone http://nant-extensions.googlecode.com/svn/ --authors-file=authors.txt --no-metadata --stdlayout $path

cd $path

# Convert tags
git for-each-ref refs/remotes/tags |
  cut -d / -f 4- |
  env GREP_OPTIONS='' grep -v @ |
  while read tagname; do
    git tag "$tagname" "tags/$tagname"
    git branch --remotes --delete "tags/$tagname"
  done

# Convert branches
git for-each-ref refs/remotes |
  cut -d / -f 3- |
  env GREP_OPTIONS='' grep -v @ |
  while read branchname; do
    git branch "$branchname" "refs/remotes/$branchname"
    git branch --remotes --delete "$branchname"
  done

echo ""
echo "Tags:"
git tag

echo "Branches:"
git branch -a
