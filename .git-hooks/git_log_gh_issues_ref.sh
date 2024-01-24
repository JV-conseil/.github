#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2024 JV-conseil
#                 All rights reserved
#====================================================

cat <<EOF

Are your referencing GitHub issues in your commits?
---------------------------------------------------

EOF
git log --all --perl-regexp --grep='(?<!Merge pull request )#\d+'
