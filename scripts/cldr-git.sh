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
    git svn clone  $svnRepoDir -A ${here}/scripts/authors-cldr.txt \
	-T trunk \
	-t tags \
	-b branches/maint \
	-b branches/srl \
	-b branches/emmons \
        -b branches/icu52m1-work \
        -b branches/jali01 \
        -b branches/jchy \
        -b branches/markus \
        -b branches/parth \
        -b branches/pedberg \
        -b branches/ryan \
        -b branches/tbishop \
        -b branches/tomzhang \
        -b branches/umesh \
        -b branches/yoshito \
	-b branches \
	$gitRepoDir/cldr || exit 1

    # NOT: mark ribnitz
#	-b branches \
    #--rewriteRoot https://unicode.org/repos/cldr || exit 1
fi


if [ -d $gitRepoDir/cldr.git ];
then
    echo "cldr.git already there, getting out"
    exit 1
fi

git init --bare $gitRepoDir/cldr.git

cd $gitRepoDir/cldr.git
git remote add srl295 https://github.com/srl295/cldr.git
git symbolic-ref HEAD refs/heads/trunk

cd $gitRepoDir/cldr
git remote add bare $gitRepoDir/cldr.git
git config remote.bare.push 'refs/remotes/*:refs/heads/*'
git push bare

cd $gitRepoDir/cldr.git

# create the master branch
git branch -m origin/trunk master || exit 1

# clean up commit msg and also delete log.txt
sh ${here}/scripts/gitfilter-cldr.sh || exit 1

du -sh lfs objects

# Migrate select file types to LFS. (this also takes awhile).
git lfs migrate import --everything --include="*.jar,*.dat,*.zip,*.gz,*.bz2" || exit 1

du -sh lfs objects
# clean up. 
git reflog expire --expire=now --all && git gc --prune=now --aggressive

du -sh lfs objects

echo 'getting out.. OK for now'


exit 0


# Conversion was successful, no longer need SubGit.
#subgit uninstall --purge $gitRepoDir/icu.git

## Make a backup
#cp -a $gitRepoDir/icu.git $gitRepoDir/backup-raw-subgit-icu.git

# Fix commit IDs and SVN rev numbers.

# clean up.
#git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
#git reflog expire --expire=now --all && git gc --prune=now --aggressive


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
