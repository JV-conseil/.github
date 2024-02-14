#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2024 JV-conseil
#                 All rights reserved
#====================================================
set -Eeou pipefail
shopt -s failglob

_jvcl_::pipenv_install() {
  (
    rm -v "Pipfile" "Pipfile.lock"
    pipenv --rm
    pipenv --clear # clear cache
  ) || :
  pipenv install --verbose -r "${_requirements}"
  pipenv run pip freeze -r "${_requirements}" |
    grep -E "## The following requirements were added by pip freeze:" -B 100
  echo
}

# shellcheck source=/dev/null
_jvcl_::venv_install() {
  virtualenv venv &&
    source venv/bin/activate &&
    pip install --upgrade pip &&
    pip install -r "${_requirements}"
}

_jvcl_::main() {
  local _requirements="./requirements.txt"
  if type pipenv; then
    _jvcl_::pipenv_install
  else
    _jvcl_::venv_install
  fi
}

_jvcl_::main
