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
# /bin/bash -c "${HOME}/GitHub/JV-conseil/.github/SETUP/install.sh"
#
#====================================================
set -Eeou pipefail
shopt -s failglob

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

_jvcl_::install_homebrew() {
  printf "\nInstalling Homebrew..."

  if type brew &>/dev/null; then
    printf " Homebrew is already installed"
    return
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

_jvcl_::install_bash() {
  printf "\nInstalling Bash..."

  if brew info bash &>/dev/null || :; then
    printf " Bash is already installed %s" "$(brew info bash | head -1)"
    return
  fi

  echo "brew install bash"

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
    printf " Brewfile is already installed"
    return
  fi

  if ! _jvcl_::ask "Do you want to launch an install from a Brewfile (that may take a while)"; then
    return
  fi

  (
    curl -fsSL "${_remote}/Brewfile" -o "${brewfile}" &&
      brew bundle install --file="${brewfile}"
  ) || :
}

_jvcl_::install_terminal_profile() {
  local _file="Ubuntu.terminal"
  printf "\nInstalling Ubutu profile for Terminal..."
  (
    curl -fsSL "${_remote}/${_file}" -o "${_local}/${_file}" &&
      open "${_local}/${_file}" &&
      printf " In Terminal > Settings > Profiles > Ubuntu\n    1. Set Ubuntu as default profile\n    2. Set font to Menlo Regular 16"
  ) || :
}

_jvcl_::diff_vscode_user_settings() {
  local _file="vscode.user.settings.json"
  printf "\nComparing VS Code User Settings... Local <-> Remote\n"
  (
    curl -fsSL "${_remote}/${_file}" -o "${_local}/${_file}" &&
      diff -wy --strip-trailing-cr "${HOME}/Library/Application Support/Code/User/settings.json" "${_local}/${_file}"
  ) || :
}

_jvcl_::inspect_profile_files() {
  local _file=""
  printf "\nInspect Profiles files...\n"
  for _file in ".bashrc" ".bash_profile" ".nanorc" ".profile" ".zprofile"; do
    (printf "\n%s\n" "${_file}" && cat "${HOME}/${_file}") || :
  done
}

_jvcl_::main() {
  local -i DEBUG=0
  local _remote="https://raw.githubusercontent.com/JV-conseil/.github/main/SETUP"
  local _local="${HOME}/Downloads"

  cat <<EOF

Mac Setup
---------

Copyright (c) 2019-2024 JV-conseil

$(curl -fsSL "${_remote}/README.md")

version
27.01.2024

EOF

  _jvcl_::install_homebrew
  _jvcl_::install_bash
  _jvcl_::install_terminal_profile
  _jvcl_::install_from_brewfile
  _jvcl_::diff_vscode_user_settings
  _jvcl_::inspect_profile_files
  cat <<EOF



Done 🎉


EOF
}

# If the script is sourced, return will return to the parent (of course), but if the script is executed, return will produce an error which gets hidden, and the script will continue execution.
# return 2>/dev/null || :

_jvcl_::main
