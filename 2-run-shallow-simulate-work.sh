#!/bin/sh
#
# Based on http://git-scm.com/book/en/Git-and-Other-Systems-Migrating-to-Git

path=/tmp/imported-shallow
cd $path

# Do some work on the branches to simulate the passing of time before we
# convert the shallow copy to a deep copy.
git for-each-ref refs/heads |
  cut -d / -f 3- |
  env GREP_OPTIONS='' grep -v @ |
  while read branch_name; do
    echo "Doing work on $branch_name"
    git checkout $branch_name

    file="file on $branch_name.txt"
    touch "$file"
    git add "$file"
    git commit -m "$file"
  done
