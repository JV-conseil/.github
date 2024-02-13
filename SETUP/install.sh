#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
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
    printf " Homebrew is already installed\n"
    return
  fi

  (
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ) || printf " ERROR: curl -fsSL .../Homebrew/install/HEAD/install.sh failed\n"

  (
    for _file in "${_dotfiles[@]}"; do
      if [[ "${_file}" =~ "nano" ]]; then continue; fi
      _file="${HOME}/${_file}"
      if [[ ! -f "${_file}" ]]; then touch "${_file}"; fi
      if grep -Fq "brew shellenv" "${_file}"; then continue; fi
      # shellcheck disable=SC2016
      printf "\n# Homebrew set PATH, MANPATH, etc...\n%s\n" 'eval "$(/opt/homebrew/bin/brew shellenv)"' | tee -a "${_file}" 1>/dev/null
    done
  ) || printf " ERROR: adding brew shellenv failed\n"
}

_jvcl_::install_bash() {
  printf "\nInstalling Bash..."

  if brew info bash &>/dev/null || :; then
    printf " Bash is already installed %s\n" "$(brew info bash | head -1)"
    return
  fi

  (
    brew install bash
  ) || printf " ERROR: brew install bash failed\n"

  (
    if ! grep -Fq "/opt/homebrew/bin/bash" "/etc/shells"; then
      printf "\n    Adding /opt/homebrew/bin/bash to /etc/shells..."
      echo "/opt/homebrew/bin/bash" | sudo tee -a "/etc/shells" 1>/dev/null
    fi
  ) || printf " ERROR: Editing /etc/shells failed"

  printf "\n    Setting default shell to Bash..." &&
    (
      chsh -s "/opt/homebrew/bin/bash"
    ) || printf " ERROR: chsh -s /opt/homebrew/bin/bash failed"

  (
    printf "\n    SHELL=%s" "${SHELL}" &&
      bash --version | head -1
  ) || printf " ERROR: bash --version | head -1 failed"
}

_jvcl_::install_from_brewfile() {
  local brewfile="${HOME}/Brewfile"

  printf "\nInstalling from Brewfile..."

  if [[ -f "${brewfile}" ]]; then
    printf " Brewfile is already installed\n"
    brew list
    return
  fi

  if ! _jvcl_::ask "Do you want to launch an install from a Brewfile (that may take a while)"; then
    return
  fi

  (
    curl -fsSL "${_remote}/Brewfile" -o "${brewfile}" &&
      brew bundle install --file="${brewfile}"
  ) || printf " ERROR: brew bundle install --file=%s failed\n" "${brewfile}"
}

_jvcl_::install_terminal_profile() {
  local _file="Ubuntu.terminal"
  printf "\nInstalling Ubutu profile for Terminal..."
  (
    curl -fsSL "${_remote}/${_file}" -o "${_local}/${_file}" &&
      # open -ga "/System/Applications/Utilities/Terminal.app" "${_local}/${_file}" &&
      open -ga "/System/Applications/Utilities/Terminal.app" "${_local}/${_file}" &&
      printf " In Terminal > Settings > Profiles > Ubuntu\n    1. Set Ubuntu as default profile\n    2. Set Font to Menlo Regular 16\n"
  ) || printf " ERROR: downloading %s failed\n" "${_file}"
}

_jvcl_::diff_vscode_user_settings() {
  local _file="vscode.user.settings.json"
  printf "\nComparing VS Code User Settings...          LOCAL                <->                        REMOTE\n"
  (
    curl -fsSL "${_remote}/${_file}" -o "${_local}/${_file}" &&
      diff -Bwy "${HOME}/Library/Application Support/Code/User/settings.json" "${_local}/${_file}"
  ) || :
}

_jvcl_::inspect_install() {
  local _file=""
  printf "\nInspect dotfiles...\n"
  for _file in "${_dotfiles[@]}"; do
    (
      cat <<EOF

-------------
${_file}
-------------
$(cat "${HOME}/${_file}")

EOF
    ) || printf "\nERROR: inspecting %s failed" "${_file}"
  done

  printf "\nInspect PATH...\n\n%s\n" "$(echo "${PATH}" | tr ':' '\n')"
}

_jvcl_::main() {
  local -i DEBUG=0
  local -a _dotfiles=(".bashrc" ".bash_profile" ".nanorc" ".profile" ".zprofile")
  local _local="${HOME}/Downloads"
  local _remote="https://raw.githubusercontent.com/JV-conseil/.github/main/SETUP"

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
  _jvcl_::inspect_install
  cat <<EOF



Done 🎉


EOF
}

# If the script is sourced, return will return to the parent (of course), but if the
# script is executed, return will produce an error which gets hidden, and the script
# will continue execution.
# return 2>/dev/null || :

_jvcl_::main
