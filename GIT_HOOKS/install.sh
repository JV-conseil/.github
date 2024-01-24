#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2024 JV-conseil
#                 All rights reserved
#====================================================

_jvcl_::git_hooks_array() {
  local -a _git_repos
  readarray -d '' _git_repos < <(find "${HOME}/GitHub" -type d -path "*/.git/hooks" -print0)
  echo "${_git_repos[@]}"
}

_jvcl_::git_log_gh_issues_ref() {
  cat <<EOF

Are your referencing GitHub issues in your commits?
---------------------------------------------------

EOF
  git log --all --perl-regexp --grep='(?<!Merge pull request )#\d+'
}

_jvcl_::git_hooks_copy() {
  local _hook="${1:-"commit-msg"}"
  local _local="./.git/hooks"
  local _remote="https://raw.githubusercontent.com/JV-conseil/.github/main/GIT_HOOKS"

  cat <<EOF

Install Git hooks in your repo
------------------------------

Copyright (c) 2019-2024 JV-conseil

version
24.01.2024

EOF

  (
    curl -sSL "${_remote}/${_hook}.py" -o "${_local}/${_hook}" &&
      chmod +x "${_local}/${_hook}" &&
      ls -FGlAhp --color=auto "${_local}" &&
      echo -e "\nThe install has completed successfuly!\n"
  ) || echo -e "\nERROR: the install did not complete successfuly\n"
}

# If the script is sourced, return will return to the parent (of course), but if the script is executed, return will produce an error which gets hidden, and the script will continue execution.
return 2>/dev/null

# shellcheck disable=SC2317
_jvcl_::git_hooks_copy "$@"
