#!/bin/sh
# Copyright (C) 2015, International Business Machines Corporation and Others. All Rights Reserved.
# This file is part of the ICU project. http://icu-project.org

# A filter to add in the ICU bug tracking numbers.

set -x
git filter-branch -f \
    --msg-filter  "sed -E -f /home/srl/src/icu-git/scripts/cldr-filter.sed" \
    --index-filter 'git rm --cached --ignore-unmatch log.txt test/log.txt' \
    -- --all
