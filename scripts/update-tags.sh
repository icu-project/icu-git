#!/bin/sh
git for-each-ref --shell --format='git tag -f $(echo %(refname) | cut -d/ -f5) %(refname)' refs/remotes/origin/tags/ | grep -v '@[0-9]' | sh
