#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2024 JV-conseil
#                 All rights reserved
#====================================================
set -Eeou pipefail
shopt -s failglob

_jvcl_::git_hooks_array() {
  local -a _git_repos
  readarray -d '' _git_repos < <(find "${HOME}/GitHub" -type d -path "*/.git/hooks" -print0)
  echo "${_git_repos[@]}"
}

_jvcl_::git_hooks_install_all() {
  local _dir
  find "${HOME}/GitHub" -type d -path "*/GitHub/*/*/.git" | while IFS= read -r _dir; do
    _dir="${_dir%/*}"
    (
      cd "${_dir}" &>/dev/null
      echo -e "\n${_dir}\n"
      ls -FGlAhp --color=auto
      # _jvcl_::git_hooks_curl
      cd - &>/dev/null
    ) || continue
  done
}

_jvcl_::git_log_gh_issues_ref() {
  cat <<EOF

Are your referencing GitHub issues in your commits?
---------------------------------------------------

EOF
  git log --all --perl-regexp --grep='(?<!Merge pull request )#\d+'
}

_jvcl_::git_hooks_curl() {
  local _hook="${1:-"commit-msg"}"
  local _local="./.git/hooks"
  local _remote="https://raw.githubusercontent.com/JV-conseil/.github/main/GIT_HOOKS"

  cat <<EOF

Install Git hooks in the current repo
-------------------------------------

Copyright (c) 2019-2024 JV-conseil

version
24.01.2024

EOF

  if [[ ! -d "${_local}" ]]; then
    echo -e "\nERROR: This folder is not a git repository\n" &&
      exit 2
  fi

  if [[ -f "${_local}/${_hook}" ]]; then
    echo -e "\nWARNING: This folder has already ${_local}/${_hook}\n\n"

    cat "${_local}/${_hook}"
    echo

    echo
    read -e -r -p "Do you want to overwrite it? [y/N]" -n 1
    if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
      echo -e "\n\nEXIT: The install was aborted\n"
      return
    fi
  fi

  (
    curl -fsSL "${_remote}/${_hook}.py" -o "${_local}/${_hook}" &&
      chmod +x "${_local}/${_hook}" &&
      ls -FGlAhp --color=auto "${_local}" &&
      echo -e "\nThe install has completed successfuly!\n"
  ) || echo -e "\nERROR: The install did not complete successfuly\n"
}

# If the script is sourced, return will return to the parent (of course), but if the script is executed, return will produce an error which gets hidden, and the script will continue execution.
return 2>/dev/null

# shellcheck disable=SC2317
_jvcl_::git_hooks_curl "$@"
