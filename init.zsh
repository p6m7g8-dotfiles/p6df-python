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

  p6df::modules::vscode::extension::install ms-python.python
  p6df::modules::vscode::extension::install ms-python.vscode-pylance
  p6df::modules::vscode::extension::install ms-python.black-formatter
  p6df::modules::vscode::extension::install ms-python.isort
  p6df::modules::vscode::extension::install ms-python.mypy-type-checker
  p6df::modules::vscode::extension::install ms-python.flake8
  p6df::modules::vscode::extension::install the0807.uv-toolkit

  p6_return_void
}

######################################################################
#<
#
# Function: str json = p6df::modules::python::vscodes::config()
#
#  Returns:
#	str - json
#
#>
######################################################################
p6df::modules::python::vscodes::config() {

  cat <<'EOF'
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true
  },
  "black-formatter.importStrategy": "fromEnvironment",
  "flake8.importStrategy": "fromEnvironment",
  "flake8.args": ["--max-line-length=120"],
  "mypy-type-checker.importStrategy": "fromEnvironment",
  "isort.args": ["--profile", "black"],
  "python.analysis.autoSearchPaths": true,
  "python.analysis.typeCheckingMode": "basic",
  "python.languageServer": "Pylance",
  "python.formatting.provider": "none",
  "python.terminal.activateEnvironment": true,
  "python.terminal.executeInFileDir": true,
  "python.terminal.launchArgs": ["--none"],
  "python.testing.pytestEnabled": true,
  "sonarlint.rules": {
    "python:S1192": { "level": "off" },
    "python:S3776": { "level": "off" }
  }
EOF

  p6_return_void
}

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

  p6df::core::homebrew::cli::brew::install uv
  p6df::core::homebrew::cli::brew::install watchman

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
#  Environment:	 P6_NL PYTHONPATH VIRTUAL_ENV_PROMPT
#>
######################################################################
p6df::modules::python::prompt::env() {

  local str=""

  local ver=$(uv python pin 2>/dev/null)
  if p6_string_blank_NOT "$ver"; then
    str="uv:\t\t  ${VIRTUAL_ENV_PROMPT:-none}$P6_NL"
  fi
  if p6_string_blank_NOT "$PYTHONPATH"; then
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
    "python3 --version 2>/dev/null | p6_filter_column_pluck 2")

  p6_return_str "$str"
}
