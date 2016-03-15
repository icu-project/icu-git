#!/bin/bash
# Copyright (C) 2015, International Business Machines Corporation and Others. All Rights Reserved.
# This file is part of the ICU project. http://icu-project.org

# Convert ICU to Git.

ME=${0}

# What are we going to work on? ICU of course.
REPONAME=icu
# where are repos stored?  (.gitignored )
REPODIR=./repos
# public URL to repo
XREPO=http://source.icu-project.org/repos/${REPONAME}
# rewrite the root to be the public URL
TOOLDIR=`dirname $ME`
COMMON_OPTS="--authors-file=../${TOOLDIR}/authors.txt --prefix=origin/ --rewrite-root=${XREPO}/"
#BASEDIR=${TOOLDIR}/git
BASEDIR=./git
VERB="clone -q"
#--preserve-empty-dirs"

# Which subrepos to do? icu4jni is smaller..
SUBS=
#SUBS+="tools "
#SUBS+="icuhtml "
#SUBS+="icu4jni "
SUBS+="icu4j "
#SUBS+="icu "
#SUBS+="data "
#SUBS+="icuapps "


if [ ! -d ${REPODIR} ]; then
    echo ${ME}: "No dir: ${REPODIR} - check REPODIR"
    exit 1
fi


if [ ! -d ${REPODIR}/${REPONAME} ]; then
    echo ${ME}: "No dir: ${REPODIR}/${REPONAME} - check REPONAME"
    exit 1
fi
# URL to repo
REPO=file://`cd  ${REPODIR}/${REPONAME}&&pwd`

# sanity check. Save hours of processing later
echo "# Fetching all authors from ${REPO} ..."
svn log --quiet "${REPO}" | grep "^r" | awk '{print $3}' | sort | uniq > scripts/authors-all.txt
cut -d' ' -f1 < scripts/authors.txt | sort > scripts/authors-configured.txt
echo "# Making sure scripts/authors.txt is up to date. List of users NOT in scripts/authors.txt:"

if fgrep -v -f scripts/authors-configured.txt scripts/authors-all.txt;
then
    echo "^^ please add these to authors.txt and try again."
    exit 1
else
    echo "# -- OK! You may proceed."
fi


#$ fgrep -v -f authors-configured.txt authors-all.txt 
#scott
#! srl@drawbridge:~/src/icu-git/scripts
#$ fgrep -v -f authors-configured.txt ^C
#(130) ! srl@drawbridge:~/src/icu-git/scripts
#



if [ ! -d "${BASEDIR}" ]; then
    mkdir -vp "${BASEDIR}"
fi

cd "${BASEDIR}" || exit 1

gitfilter()
{
    ../${TOOLDIR}/gitfilter.sh
}

dosub()
{
    if [[ $# != 1 ]]; then
        echo 'usage: dosub <svnpath>'
        exit 1
    fi
    SUB=$1
    if [[ -d "${SUB}" ]]; then
        echo "Already a dir: ${SUB}"
        exit 1
    fi
    echo "# ${SUB}"
    set -o xtrace
    git svn ${VERB} ${COMMON_OPTS} "${REPO}" "${SUB}" -T "${SUB}/trunk"  -t "${SUB}/tags" -b "${SUB}/branches" --ignore-paths="^/icu4j/(?:trunk|tags/.*|branches/.*)/main/shared/data" || exit 1
    ( cd "${SUB}" && ../../${TOOLDIR}/gitfilter.sh ) || exit 1
    #git remote add github "git@github.com:icu-project/${SUB}.git"
    set +o xtrace
}

echo "BASEDIR=${BASEDIR}"
echo "REPO=${REPO}"

for sub in ${SUBS}; do
    dosub "${sub}"
    # should have done this a long time ago. Maybe 2006.
    if [ -d icu & ! -d icu4c ]; then
	mv -v icu icu4c
    fi
    if [ -d tools & ! -d icu-tools ]; then
	mv -v tools icu-tools
    fi
done


