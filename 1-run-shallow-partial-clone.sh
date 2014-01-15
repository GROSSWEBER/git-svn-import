#!/bin/sh
#
# Based on http://git-scm.com/book/en/Git-and-Other-Systems-Migrating-to-Git

path=/tmp/imported-shallow
rm -rf $path

# The (no author) line in users.txt needs to be there because the first commit is done by the Google Code system
# It requires an email address, otherwise git would refuse to use it.
#
# Fetch from commit 120 to the HEAD -- which represents only part of the history.
git svn clone http://nant-extensions.googlecode.com/svn/ --authors-file=authors.txt --stdlayout -r120:HEAD $path
