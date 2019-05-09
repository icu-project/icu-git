#!/bin/sh

svnRepoDir=file://$(pwd)/repos/cldr
gitRepoDir=$(pwd)/git
here=$(pwd)
cd ${gitRepoDir}/cldr.git
git branch -c origin/maint-30 branches/maint/maint-30
git branch -c origin/maint-35 branches/maint/maint-35

for sub in $(svn list ${svnRepoDir}/branches | tr -d /);
do
    #echo subbranch ${sub}
    # will fail for srl, maint, ..
    git branch -c origin/${sub} branches/${sub}
done
