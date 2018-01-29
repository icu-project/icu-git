#!/bin/bash
# © 2016 and later: Unicode, Inc. and others.
# License & terms of use: http://www.unicode.org/copyright.html
# Copyright (C) 2015, International Business Machines Corporation and Others. All Rights Reserved.
# This file is part of the ICU project. http://icu-project.org

# Convert ICU to Git.

set -x
subgit install --rebuild repos/icu/ && (cd git/icu.git && sh ../../scripts/gitfilter.sh )

