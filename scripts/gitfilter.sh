#!/bin/sh
# Copyright (C) 2015, International Business Machines Corporation and Others. All Rights Reserved.
# This file is part of the ICU project. http://icu-project.org

# A filter to add in the ICU bug tracking numbers.

set -x
git filter-branch --msg-filter  'sed -e "s%ticket:\([0-9]*\)[ :]*%https://ssl.icu-project.org/trac/ticket/\1\\
 %g"'  -- --all
