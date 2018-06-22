#!/bin/bash
# © 2016 and later: Unicode, Inc. and others.
# License & terms of use: http://www.unicode.org/copyright.html
# Copyright (C) 2015, International Business Machines Corporation and Others. All Rights Reserved.
# This file is part of the ICU project. http://icu-project.org

# Convert ICU to Git.

if [ -d git/icu.git ];
then
    echo cowardly refusing to overwrite git/icu.git
    exit 1
fi
set -x
git init --bare git/icu.git
subgit configure --layout auto file://$(pwd)/repos/icubis git/icu.git
cp subgit.conf git/icu.git/subgit/config
subgit install --rebuild git/icu.git && (cd git/icu.git && sh ../../scripts/gitfilter.sh )
