#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2024 JV-conseil
#                 All rights reserved
#
# A hook script to check the commit log message.
# Called by "git commit" with one argument, the name of the file
# that has the commit message. The hook should exit with non-zero
# status after issuing an appropriate message if it wants to stop the
# commit. The hook is allowed to edit the commit message file.
#
# To enable this hook, rename this file to "commit-msg".
#
# ====================================================

import re
import sys

commit_msg = (
    # "Merge branch 'dule-prod' of github.com:SDU-RIO-Explore/YERUN into dule-prod"
    # "test"
    "#1 test"
    "test #12"
)

print("commit_msg", commit_msg)
# sys.exit(0)

"""1. Allow automatic commit messages in the form
Merge branch 'dule-prod' of github.com:SDU-RIO-Explore/YERUN into dule-prod
"""
merge_branch = re.compile(r"^Merge branch .+ of .+ into .+$")
if re.search(merge_branch, commit_msg):
    print("merge_branch", merge_branch)
    sys.exit(0)

"2. Block commits with no reference to an issue in the commit message"
issue_tag = re.compile(r"#[1-9]\d{,2}(?!\d)")
if not re.search(issue_tag, commit_msg):
    print(
        """Hi

Your commit message must contains at least one reference
to a GitHub issue e.g.:

#123 Fix a Bug 🪲
#123 #321 Fix a Bug 🪲

On GitHub Desktop in the commit Summary field, typing # (hashtag)
will trigger suggestions of issues to reference.

You can also pick one of the issues on GitHub
issues

If no issue match your commit maybe creating one would be a
good idea 😉

Cheers 👋
"""
    )
    sys.exit(1)
