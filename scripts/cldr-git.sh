#!/bin/bash
# © 2016 and later: Unicode, Inc. and others.
# License & terms of use: http://www.unicode.org/copyright.html
# Copyright (C) 2015, International Business Machines Corporation and Others. All Rights Reserved.
# This file is part of the ICU project. http://icu-project.org

# Convert the ICU source repository from SVN to Git.

# Locations/paths. (no trailing slash).
svnRepoDir=file://$(pwd)/repos/cldr
gitRepoDir=$(pwd)/git
here=$(pwd)
#icuConversionHelpersDir=/data/icu/icu-git
#userHome=/home/jefgen
set -x

# Set the paths in the SubGit configuration file.
#sed -i "s%REPLACEME-CONVERSION-HELPERS%$icuConversionHelpersDir%g" $icuConversionHelpersDir/subgit.conf
#sed -i "s%REPLACEME-ICU-SVN%$svnRepoDir%g" $icuConversionHelpersDir/subgit.conf
#sed -i "s%REPLACEME-USER-HOME%$userHome%g" $icuConversionHelpersDir/subgit.conf

#git init --bare $gitRepoDir/icu.git || exit 1
#subgit configure --layout auto file://$svnRepoDir $gitRepoDir/icu.git || exit 1

# Replace the SubGit config with our custom configuration.
#mv -v $gitRepoDir/icu.git/subgit/config $gitRepoDir/icu.git/subgit/subgit.conf~
#cp -v $icuConversionHelpersDir/subgit.conf $gitRepoDir/icu.git/subgit/config

# Actually convert from SVN to git (this takes a long time).
#subgit import $gitRepoDir/icu.git || exit 1


if [ -d $gitRepoDir/cldr ];
then
    echo "cldr already is there- skipping clone"
else
    git svn clone  $svnRepoDir -A ${here}/scripts/authors-cldr.txt --stdlayout $gitRepoDir/cldr || exit 1
fi


exit 0


cd $gitRepoDir/icu.git

# Conversion was successful, no longer need SubGit.
#subgit uninstall --purge $gitRepoDir/icu.git

# clean up.
git reflog expire --expire=now --all && git gc --prune=now --aggressive

## Make a backup
#cp -a $gitRepoDir/icu.git $gitRepoDir/backup-raw-subgit-icu.git

# Fix commit IDs and SVN rev numbers.
sh ${here}/scripts/gitfilter-cldr.sh

# clean up.
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all && git gc --prune=now --aggressive

# Migrate select file types to LFS. (this also takes awhile).
git lfs migrate import --everything --include="*.jar,*.dat,*.zip,*.gz,*.bz2" || exit 1

# clean up.
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all && git gc --prune=now --aggressive

# Fix the .gitattributes files. (this also takes a long time).
git filter-branch --tree-filter "perl $here/scripts/clean-gitattributes.pl" --tag-name-filter cat --prune-empty -- --all || exit 1

# clean up.
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all && git gc --prune=now --aggressive

# Output information on the repo size.
git lfs migrate info --everything --top=25
git count-objects -vH
du -sh .
du -sh lfs/
