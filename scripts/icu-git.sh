#!/bin/bash
# © 2016 and later: Unicode, Inc. and others.
# License & terms of use: http://www.unicode.org/copyright.html
# Copyright (C) 2015, International Business Machines Corporation and Others. All Rights Reserved.
# This file is part of the ICU project. http://icu-project.org

# Convert ICU to Git.

if [ -d git/icu.git ];
then
    echo cowardly refusing to overwrite git/icu.git
    exit 1
fi
set -x
git init --bare git/icu.git
subgit configure --layout auto file://$(pwd)/repos/icubis git/icu.git
mv -v git/icu.git/subgit/config subgit.conf~
cp -v subgit.conf git/icu.git/subgit/config
subgit install --rebuild git/icu.git || exit 1

cd git/icu.git && sh ../../scripts/gitfilter.sh 

## If successful, then we no longer need SubGit
subgit uninstall --purge git/icu.git

## clean up anything leftover from the filter-branch.
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin ; git reflog expire --expire=now --all
git gc --prune=now --aggressive

## Migrate select file types to LFS. (this takes awhile).
git lfs migrate import --everything --include="*.jar,*.dat,*.zip,*.gz,*.bz2,*.gif"

git reflog expire --expire=now --all && git gc --prune=now --aggressive

git filter-branch --tree-filter 'perl clean-gitattributes.pl' --tag-name-filter cat --prune-empty -- --all