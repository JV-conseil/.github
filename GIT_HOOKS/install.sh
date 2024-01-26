#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2024 JV-conseil
#                 All rights reserved
#
# To test localy
# /bin/bash -c "${HOME}/GitHub/JV-conseil/.github/GIT_HOOKS/install.sh"
#
# shellcheck disable=SC2317
#
#====================================================
set -Eeou pipefail
shopt -s failglob

declare -i DEBUG=0

cd() {
  builtin cd "$@" || return
  printf "\n%s\n\n" "$@"
  ls -FGlAhp --color=auto "$@"
}

# Usage: throbber & your_process ; kill %-1
throbber() {
  printf "Please wait..."
  while true; do
    printf "."
    sleep .3
  done
}

_jvcl_::ask() {
  local _prompt=${1:-"Houston Do You Copy"}
  # read -e -r -p "${_prompt}? [y/N]" -n 1
  read -rep $'\n'"${_prompt}? [y/N]" -n 1
  if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    true
  else
    false
  fi
}

_jvcl_::cmd_find_git_repo() {
  _cmd_find_git_repo=(
    "find" "${HOME}/GitHub" "-type" "d" "-path" "*/GitHub/*/*/.git"
  )
}

_jvcl_::cache_git_repo_to_array() {
  local -a _cmd_find_git_repo

  _jvcl_::cmd_find_git_repo
  _cmd_find_git_repo+=("-print0")

  throbber &
  readarray -d '' _cache_git_repo_to_array < <(
    "${_cmd_find_git_repo[@]}"
  )
  kill %-1
}

_jvcl_::select_git_repo() {
  local _repo
  printf "\nSelect a Git repository\n\n"
  select _repo in "${_cache_git_repo_to_array[@]}"; do
    test -n "${_repo}" && break
    printf ">>> Invalid Selection\n"
  done
  _repo="${_repo%/*}"
  if [[ ! -d "${_repo}" ]]; then
    return 1
  fi
  # cd "${_repo}" &&
  #   printf "\n%s\n\n" "${_repo}" &&
  #   ls -FGlAhp --color=auto "${_repo}"
  cd "${_repo}"
}

_jvcl_::git_log_gh_issues_references() {
  if ! _jvcl_::ask "Are your referencing GitHub issues in your commits"; then
    return
  fi

  _jvcl_::select_git_repo

  printf "\nCommits found\n\n"
  if [[ "${DEBUG}" -gt 0 ]]; then
    git log --all --perl-regexp \
      --grep='(?<!Merge pull request |&)#\d+'
  else
    git log --all --perl-regexp \
      --grep='(?<!Merge pull request |&)#\d+' \
      --author='^((?!JV-conseil|JV conseil).*)$'
  fi

  _jvcl_::git_log_gh_issues_references
}

# shellcheck disable=SC2120
_jvcl_::git_hooks_curl() {
  local _hook="${1:-"commit-msg"}"
  local _local="./.git/hooks"

  if [[ ! -d "${_local}" ]]; then
    # echo -e "\nERROR: This folder is not a git repository\n" &&
    #   exit 2

    _jvcl_::select_git_repo
  fi

  local _prior_hook=""
  if [[ -f "${_local}/${_hook}" ]]; then
    _prior_hook="${_local}/${_hook}.$(date +'%Y%m%d')"
    mv "${_local}/${_hook}" "${_prior_hook}"
  fi

  (
    if [[ "${DEBUG}" -gt 0 ]]; then
      cp -pv "./GIT_HOOKS/${_hook}.py" "${_local}/${_hook}"
    else
      curl -fsSL "${_remote}/${_hook}.py" -o "${_local}/${_hook}"
    fi

    chmod +x "${_local}/${_hook}"

    if [[ -f "${_prior_hook}" ]]; then
      # To just test whether two files are the same, use cmp -s
      if cmp -s "${_local}/${_hook}" "${_prior_hook}"; then
        rm "${_prior_hook}"
      else
        printf "\nAn older hook already installed has been saved\n%s\n\n" "${_prior_hook}"
        if [[ "${DEBUG}" -gt 0 ]]; then
          cat "${_prior_hook}"
          echo
        fi
      fi
    fi

    printf "\nThe install has completed successfuly!\n\n"

    if [[ "${DEBUG}" -gt 0 ]]; then
      printf "%s\n\n" "${_local}" &&
        ls -FGlAhp --color=auto "${_local}"
    fi

  ) || echo -e "\nERROR: The install did not complete successfuly\n"

  if _jvcl_::ask "Do you want to perform install in another repo"; then
    _jvcl_::select_git_repo
    _jvcl_::git_hooks_curl
  fi
}

_jvcl_::install_all() {
  local _repo

  if ! _jvcl_::ask "Do you want to install in all your repos"; then
    return
  fi

  for _repo in "${_cache_git_repo_to_array[@]}"; do
    cd "${_repo}"
    printf "\nDISABLED: Will run _jvcl_::git_hooks_curl...\n"
  done
}

_jvcl_::main() {
  local _remote="https://raw.githubusercontent.com/JV-conseil/.github/main/GIT_HOOKS"

  cat <<EOF

Install Git hooks
-----------------

Copyright (c) 2019-2024 JV-conseil

$(curl -fsSL "${_remote}/README.md")

version
25.01.2024

EOF

  _jvcl_::cache_git_repo_to_array
  _jvcl_::git_hooks_curl
  _jvcl_::install_all
  _jvcl_::git_log_gh_issues_references
}

# If the script is sourced, return will return to the parent (of course), but if the script is executed, return will produce an error which gets hidden, and the script will continue execution.
# return 2>/dev/null || :

_jvcl_::main
