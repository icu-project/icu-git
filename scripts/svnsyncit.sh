#!/bin/sh
# Copyright (C) 2012, International Business Machines Corporation and Others. All Rights Reserved.
# This file is part of the ICU project.

# A script to svn sync some directory.

if [ $# -lt 1 ];
then
    echo usage: $0 '<dir> ...'
    exit 1
fi

oldpwd=`pwd`

for dir in $@;
do
    cd $oldpwd
    if [ ! -d "$dir" ];
    then
	echo "not a dir: $dir"
	exit 2
    fi

    cd "$dir" || exit 3
    url="file://`pwd`"
    echo svnsync sync $url
    svnsync sync $url || exit 4
done
