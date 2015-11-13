#!/bin/sh
# Copyright (C) 2012, International Business Machines Corporation and Others. All Rights Reserved.
# This file is part of the ICU project.

# A script to svn sync some directory.

if [ $# -ne 1 ];
then
    echo usage: $0 '<dir>'
    exit 1
fi

if [ ! -d "$1" ];
then
    echo "not a dir: $1"
    exit 2
fi

cd "$1" || exit 3
url="file://`pwd`"
echo svnsync sync $url
exec svnsync sync $url
