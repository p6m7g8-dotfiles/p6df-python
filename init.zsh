# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::python::deps()
#
#>
######################################################################
p6df::modules::python::deps() {
  ModuleDeps=(
    p6m7g8-dotfiles/p6df-zsh
    p6m7g8-dotfiles/p6python
    matthiasha/zsh-uv-env
    astral-sh/uvz
    ohmyzsh/ohmyzsh:plugins/uv
  )
}

######################################################################
#<
#
# Function: p6df::modules::python::vscodes()
#
#>
######################################################################
p6df::modules::python::vscodes() {

  code --install-extension ms-python.python
  code --install-extension ms-python.vscode-pylance
  code --install-extension ms-python.black-formatter
  code --install-extension ms-python.isort
  code --install-extension ms-python.mypy-type-checker
  code --install-extension ms-python.flake8
  code --install-extension the0807.uv-toolkit

  p6_return_void
}

#{
#  "python.analysis.typeCheckingMode": "basic",
#  "python.formatting.provider": "none",
#  "editor.formatOnSave": true,
#  "[python]": {
#    "editor.defaultFormatter": "ms-python.black-formatter"
#  }
#}

######################################################################
#<
#
# Function: p6df::modules::python::external::yum()
#
#>
######################################################################
p6df::modules::python::external::yum() {

  sudo yum install gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::external::brew()
#
#>
######################################################################
p6df::modules::python::external::brew() {

  p6df::modules::homebrew::cli::brew::install uv
  p6df::modules::homebrew::cli::brew::install watchman

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::init(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#  Environment:	 HOME
#>
######################################################################
p6df::modules::python::init() {
  local _module="$1"
  local dir="$2"

  p6_bootstrap "$dir"
  p6_path_if "$HOME/.local/bin"

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::python::prompt::env()
#
#  Returns:
#	str - str
#
#  Environment:	 PYTHONPATH VIRTUAL_ENV_PROMPT
#>
######################################################################
p6df::modules::python::prompt::env() {

  local str=""

  local ver=$(uv python pin 2>/dev/null)
  if ! p6_string_blank "$ver"; then
    str="uv:\t\t  $VIRTUAL_ENV_PROMPT$P6_NL"
  fi
  if ! p6_string_blank "$PYTHONPATH"; then
    str="${str}pythonpath:\t  $PYTHONPATH$P6_NL"
  fi

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: str str = p6df::modules::python::prompt::lang()
#
#  Returns:
#	str - str
#
#>
######################################################################
p6df::modules::python::prompt::lang() {

  local str
  str=$(p6df::core::lang::prompt::lang \
    "py" \
    "uv python pin 2>/dev/null" \
    "python --version 2>/dev/null | awk '{print $2}'")

  p6_return_str "$str"
}
