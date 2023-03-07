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
    pyenv/pyenv
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
  code --install-extension kiteco.kite
  code --install-extension ms-python.python
  code --install-extension ms-python.vscode-pylance

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

  brew install watchman

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
  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-python/share/.kite" ".kite"

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
# Function: p6df::modules::python::langs::install()
#
#>
######################################################################
p6df::modules::python::langs::install() {

  # get the shiny one
  local latest
  latest=$(p6df::modules::python::pyenv::latest)
  pyenv install -s $latest
  pyenv global $latest
  pyenv rehash

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::pyenv::latest()
#
#>
######################################################################
p6df::modules::python::pyenv::latest() {

  pyenv install -l | p6_filter_select '^ *3' | p6_filter_exclude "[a-z]" | p6_filter_last "1" | p6_filter_spaces_strip
}

######################################################################
#<
#
# Function: p6df::modules::python::langs::nuke()
#
#>
######################################################################
p6df::modules::python::langs::nuke() {

  # nuke the old one
  local previous
  previous=$(p6df::modules::python::pyenv::latest::installed)
  pyenv uninstall -f $previous

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::pyenv::latest::installed()
#
#>
######################################################################
p6df::modules::python::pyenv::latest::installed() {

  pyenv install -l | p6_filter_select '^ *3' | p6_filter_exclude "[a-z]" | p6_filter_from_end "2" | p6_filter_spaces_strip
}

######################################################################
#<
#
# Function: p6df::modules::python::langs::pull()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::python::langs::pull() {

  p6_run_dir "$P6_DFZ_SRC_DIR/pyenv/pyenv" p6_git_p6_pull

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::langs::eggs()
#
#>
######################################################################
p6df::modules::python::langs::eggs() {

  Eggs=(
    "pip"
    "wheel"
    "autopep8"
    "bandit"
    "black"
    "flake9"
    "jedi"
    "mpyp"
    "nose"
    "pep8"
    "poetry"
    "prospector"
    "pycodestyle"
    "pydocstyle"
    "pylama"
    "pylint"
    "pyre-check"
    "tox"
    "yamllint"
    "yapf"
  )

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::langs::pipenv()
#
#>
######################################################################
p6df::modules::python::langs::pipenv() {

  pip install pipenv

  # @Eggs
  p6df::modules::python::langs::eggs

  local egg
  for egg in $Eggs[@]; do
    pipenv install $egg
  done

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::pip::env::prompt::info()
#
#  Returns:
#	str - str
#
#  Environment:	 COMMANDLINE PIPENV_ACTIVE
#>
######################################################################
p6df::modules::pip::env::prompt::info() {

  local env=$(p6_run_code pipenv --venv 2>/dev/null)
  local str
  if ! p6_string_blank "$env"; then
    env=$(p6_uri_name "$env")

    local astr
    if p6_string_eq "$PIPENV_ACTIVE" "1"; then
      astr="active"
    else
      astr="off"
    fi

    str="pipenv:\t\t  $env ($astr)"
    p6_return_str "$str"
  else
    p6_return_void
  fi
}

# from ohmyzsh/plugins/pipenv
_pipenv() {
  eval $(env COMMANDLINE="${words[1, $CURRENT]}" _PIPENV_COMPLETE=complete-zsh pipenv)
}

######################################################################
#<
#
# Function: p6df::modules::python::langs::pip::upgrade()
#
#>
######################################################################
p6df::modules::python::langs::pip::upgrade() {

  pip install pip --upgrade
}

######################################################################
#<
#
# Function: p6df::modules::python::langs::pip()
#
#>
######################################################################
p6df::modules::python::langs::pip() {

  p6df::modules::python::langs::pip::upgrade

  # @Eggs
  p6df::modules::python::langs::eggs

  local egg
  for egg in $Eggs[@]; do
    pip install $egg
  done
  pyenv rehash

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::init()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::python::init() {

  compdef _pipenv pipenv

  p6df::core::lang::mgr::init "$P6_DFZ_SRC_DIR/pyenv/pyenv" "py"
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
#  Environment:	 PYENV_ROOT PYTHON_PATH
#>
######################################################################
p6df::modules::py::env::prompt::info() {

  local str="pyenv_root:\t  $PYENV_ROOT"
  if ! p6_string_blank "$PYTHON_PATH"; then
    str=$(p6_string_append "$str" "python_path:\t  $PYTHON_PATH" "$P6_NL")
  fi

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: p6_python_path_if(dir)
#
#  Args:
#	dir -
#
#  Environment:	 PYTHON_PATH
#>
######################################################################
p6_python_path_if() {
  local dir="$1"

  if p6_dir_exists "$dir"; then
    if p6_string_blank "$PYTHON_PATH"; then
      p6_env_export PYTHON_PATH "$dir"
    else
      p6_env_export PYTHON_PATH "$dir:$PYTHON_PATH"
    fi
  fi

  p6_return_void
}
