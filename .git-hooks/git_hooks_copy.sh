#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2024 JV-conseil
#                 All rights reserved
#====================================================

_jvcl_::git_hooks_copy() {
  local _file _src _dir=(".git-hooks" ".git/hooks")

  # 1) Delete errand hooks no longer in sync with the template folder
  find "./${_dir[1]}" -type f ! -name "*.sample" | while IFS= read -r _file; do
    rm "${_file}"
  done

  # 2) Copy the hooks in sync with the template folder
  find "./${_dir[0]}"/*.py -type f | while IFS= read -r _src; do

    _file="${_src/${_dir[0]}/${_dir[1]}}"
    _file="${_file/.py/}"

    (
      cp -v "${_src}" "${_file}" &&
        chmod +x "${_file}" &&
        ls "./${_dir[1]}"
    ) || echo "ERROR copying ${_src} to ${_dir[1]} failed."
  done
}

_jvcl_::git_hooks_copy
