#!/bin/sh

svnRepoDir=file://$(pwd)/repos/cldr
gitRepoDir=$(pwd)/git
here=$(pwd)
ZBRANCHES="maint srl emmons jali01 jchye markus parth pedberg ryan tbishop tomzhang umesh yoshito"

# ok, find the top level mappings
for branch in ${ZBRANCHES};
do
#    echo
#    echo ${branch}
    svn list ${svnRepoDir}/branches/${branch} | fgrep -q  -v / && (echo error branch ${branch} has a non-directory child. Exclude? ; exit 1)
    for sub in $(svn list ${svnRepoDir}/branches/${branch} | tr -d /);
    do
	echo git branch -c origin/${sub} branches/${branch}/${sub}
    done
done
