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
# /bin/bash -c "${HOME}/GitHub/JV-conseil/.github/SHELL/install.sh"
#
#====================================================
set -Eeou pipefail
shopt -s failglob

declare -i DEBUG=0

_jvcl_::install_hombrew() {
  printf "\nInstalling Homebrew..."

  if type brew &>/dev/null; then
    printf " Homebrew is already installed"
    return
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

_jvcl_::install_bash() {
  printf "\nInstalling Bash..."

  if [ $((${BASH_VERSION:0:1})) -ge 5 ]; then
    printf " Bash is already installed %s" "$(bash --version | head -1)"
    return
  fi

  brew install bash

  if ! grep -F -q "/opt/homebrew/bin/bash" "/etc/shells"; then
    printf "\nAdding /opt/homebrew/bin/bash to /etc/shells...\n"
    echo "/opt/homebrew/bin/bash" | sudo tee -a "/etc/shells" >/dev/null
  fi

  printf "\nSetting default shell to Bash...\n"
  chsh -s "/opt/homebrew/bin/bash"

  printf "\nSHELL=%s\n" "${SHELL}"
  bash --version | head -1
}

_jvcl_::install_from_brewfile() {
  local brewfile="${HOME}/Brewfile"

  printf "\nInstalling from Brewfile..."

  if [[ -f "${brewfile}" ]]; then
    printf " There is a Brewfile already"
    return
  fi

  curl -fsSL "${_remote}/Brewfile" -o "${brewfile}"
  brew bundle install --file="${brewfile}"
}

_jvcl_::main() {
  local _remote="https://raw.githubusercontent.com/JV-conseil/.github/main/SETUP"

  cat <<EOF

Mac Setup
---------

Copyright (c) 2019-2024 JV-conseil

$(curl -fsSL "${_remote}/README.md")

version
25.01.2024

EOF

  _jvcl_::install_hombrew
  _jvcl_::install_bash
  _jvcl_::install_from_brewfile
  echo
}

# If the script is sourced, return will return to the parent (of course), but if the script is executed, return will produce an error which gets hidden, and the script will continue execution.
# return 2>/dev/null || :

_jvcl_::main
