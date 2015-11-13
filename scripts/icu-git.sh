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
SUBS+="tools "
SUBS+="icuhtml "
SUBS+="icu4jni "
SUBS+="icu4j "
SUBS+="icu "
SUBS+="data "
SUBS+="icuapps "


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
    git svn ${VERB} ${COMMON_OPTS} "${REPO}" "${SUB}" -T "${SUB}/trunk"  -t "${SUB}/tags" -b "${SUB}/branches" || exit 1
    ( cd "${SUB}" && ../../${TOOLDIR}/gitfilter.sh ) || exit 1
    set +o xtrace
}

echo "BASEDIR=${BASEDIR}"
echo "REPO=${REPO}"

for sub in ${SUBS}; do
    dosub "${sub}"
done

# should have done this a long time ago. Maybe 2006.
if [ -d icu & ! -d icu4c ]; then
    mv -v icu icu4c
done
