#!/bin/bash
# Copyright (C) 2012, International Business Machines Corporation and Others. All Rights Reserved.
# This file is part of the ICU project.

# A script to initialize a new svn repository.

if [ $# -ne 2 ];
then
    echo usage $0 SHORTNAME URL
    exit 1
fi

short=$1
url=$2

if [ -d $short ];
then
    echo "Already exists: $short"
    exit 2
fi

set -x
svnadmin create $short
ln -s `which true` $short/hooks/pre-revprop-change
svnsync init file://`pwd`/$short $url
