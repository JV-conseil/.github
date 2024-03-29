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
from hashlib import blake2s
from itertools import zip_longest
from subprocess import check_output

"Collect the parameters"

commit = ["hook", "commit_msg_filepath", "type", "hash", "branch", "github"]
commit = zip_longest(commit, sys.argv, fillvalue="")
commit = dict(commit)

"Figure out which branch we're on"

cmd = {
    "branch": ("git", "symbolic-ref", "--short", "HEAD"),
    "github": ("git", "config", "--get", "remote.origin.url"),
    "user": ("git", "config", "user.name"),
}
for key, command in cmd.items():
    value = check_output(command).decode().strip()
    if not value:
        continue
    commit[key] = value

# "Check the parameters"
# print(commit)

# if blake2s(commit["user"].encode(), digest_size=5).hexdigest() in ("b623907a87",):
#     sys.exit(0)

"Read commit message"

with open(commit["commit_msg_filepath"], "r") as f:
    commit_msg = f.read()

    # print("commit_msg", commit_msg)
    # sys.exit(0)

    """1. Allow automatic commit messages in the form of
    Merge branch 'dule-prod' of github.com:SDU-RIO-Explore/YERUN into dule-prod
    Merge branch 'main' into aalborg
    """
    merge_branch = re.compile(r"^Merge branch .+ into .+$")
    if re.search(merge_branch, commit_msg):
        # print(merge_branch)
        sys.exit(0)

    "2. Block commits with no reference to an issue in the commit message"
    issue_tag = re.compile(r"#[1-9]\d{,2}(?!\d)")
    if not re.search(issue_tag, commit_msg):
        print(
            f"""Hi {commit["user"]} 👋

Your commit message must contains at least one reference to a GitHub issue 👇

#123 Fix a Bug 🪲
#123 #321 Fix a Bug 🪲
ulynks/docs#38 Fix a Bug 🪲

On GitHub Desktop in the commit Summary field, typing # (hashtag) will trigger
suggestions of issues to reference.

You can also pick one of the issues on GitHub
{commit['github'][:-4]}/issues

You can point to another repo's issues as such
owner/repo#digit e.g.: ulynks/docs#38 Fix a Bug 🪲

If no issue match your commit maybe creating one would be a good idea 😉

"""
        )
        sys.exit(1)
