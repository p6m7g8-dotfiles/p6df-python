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
    pyenv/pyenv
    ohmyzsh/ohmyzsh:plugins/poetry
    ohmyzsh/ohmyzsh:plugins/poetry-env
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

  p6df::modules::homebrew::cli::brew::install watchman

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::home::symlink()
#
#  Environment:	 P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::python::home::symlink() {

  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-python/share/.pip" ".pip"
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
  p6df::modules::python::langs::pip

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

  compdef _pipenv pipenv

  p6_path_if "$HOME/.local/bin" "$PATH" # XXX Must be before shims
  p6df::core::lang::mgr::init "$P6_DFZ_SRC_DIR/pyenv/pyenv" "py"
  # eval "$($bin init --path)"

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::pipenv::prompt::info()
#
#  Returns:
#	str - str
#
#  Environment:	 P6_DFZ_REAL_CMD PIPENV_ACTIVE
#>
######################################################################
p6df::modules::pipenv::prompt::info() {

  local cache_key="pipenv"

  case "$P6_DFZ_REAL_CMD" in
  *pipenv* | *cd*)
    grep -v "^$cache_key=" "$P6_DFZ_PROMPT_CACHE" >"$P6_DFZ_PROMPT_CACHE.tmp" && mv "$P6_DFZ_PROMPT_CACHE.tmp" "$P6_DFZ_PROMPT_CACHE"
    local env=$(p6_run_code pipenv --venv 2>/dev/null)
    echo "$cache_key=$env" >>"$P6_DFZ_PROMPT_CACHE"
    ;;
  esac

  local env=$(grep -E "^$cache_key=" "$P6_DFZ_PROMPT_CACHE" | tail -1 | cut -d '=' -f 2)

  if ! p6_string_blank "$env"; then
    env=$(p6_uri_name "$env")
    local astr
    if p6_string_eq "$PIPENV_ACTIVE" "1"; then
      astr="active"
    else
      astr="off"
    fi

    local str="pipenv:\t\t  $env ($astr)"
    p6_return_str "$str"
  else
    p6_return_void
  fi
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
p6df::modules::py::env::prompt::info() {

  local str="pyenv_root:\t  $PYENV_ROOT"
  if ! p6_string_blank "$PYTHONPATH"; then
    str=$(p6_string_append "$str" "pythonpath:\t  $PYTHONPATH" "$P6_NL")
  fi

  p6_return_str "$str"
}
