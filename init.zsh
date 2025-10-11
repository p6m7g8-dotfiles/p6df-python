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
    astral-sh/zsh-uv-env
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

  code --install-extension FedericoVarela.pipenv-scripts
  code --install-extension ms-python.vscode-pylance
  code --install-extension ms-python.pylint
  code --install-extension ms-python.flake8
  code --install-extension ms-python.mypy-type-checker
  code --install-extension ms-python.black-formatter
  code --install-extension ms-python.isort
  code --install-extension the0807.uv-toolkit
  code --install-extension zeshuaro.vscode-python-poetry

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

  p6df::modules::homebrew::cli::brew::install uv
  p6df::modules::homebrew::cli::brew::install watchman

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::langs()
#
#>
######################################################################
p6df::modules::python::langs() {

  p6df::modules::python::langs::pull
  p6df::modules::python::langs::nuke
  p6df::modules::python::langs::install

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
#  Environment:	 HOME P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::python::init() {
  local _module="$1"
  local dir="$2"

  p6_bootstrap "$dir"

  p6df::core::lang::mgr::init2 "py"
  # eval "$($bin init --path)"

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::py::env::prompt::info()
#
#  Returns:
#	str - str
#
#  Environment:	 PYENV_ROOT PYTHONPATH
#>
######################################################################
p6df::modules::uv::env::prompt::info() {

  local str=""

  local ver=$(uv python pin 2>/dev/null)
  if ! p6_string_blank "$ver"; then
    str="uv:\t\t  $ver [$VIRTUAL_ENV_PROMPT] $P6_NL"
  fi
  if ! p6_string_blank "$PYTHONPATH"; then
    str="${str}pythonpath:\t  $PYTHONPATH $P6_NL"
  fi

  p6_return_str "$str"
}
