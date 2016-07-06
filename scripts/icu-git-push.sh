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
#SPLIT_OPTS="--ignore-paths='^/icu4j/(?:trunk|tags/.*|branches/.*)/main/shared/data'"
#BASEDIR=${TOOLDIR}/git
BASEDIR=./git
VERB="clone -q"
#--preserve-empty-dirs"

# Which subrepos to do? icu4jni is smaller..
SUBS=
#SUBS+="tools "
#SUBS+="icuhtml "
SUBS+="icu4jni "
SUBS+="icu4j "
SUBS+="icu4c "
#SUBS+="data "
#SUBS+="icuapps "



for sub in ${SUBS}; do
    ( cd "git/${sub}" && git push --all -f github && git push --tags github )
done


