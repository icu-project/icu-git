#!/bin/sh
# Copyright (C) 2015, International Business Machines Corporation and Others. All Rights Reserved.
# This file is part of the ICU project. http://icu-project.org

# A filter to add in the ICU bug tracking numbers.

set -x
git filter-branch -f --msg-filter  'sed -re "1 s%^[ ]*(ticket|fixes)[ :]*([0-9]*)[ :]*(.*)$%\3\\
\\
X-Trac-URL: https://ssl.icu-project.org/trac/ticket/\2%"'  -- --all
