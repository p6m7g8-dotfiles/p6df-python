######################################################################
#<
#
# Function: p6df::modules::python::deps()
#
#>
######################################################################
p6df::modules::python::deps() {
  ModuleDeps=(
    p6m7g8-dotfiles/p6common
    p6m7g8-dotfiles/p6df-zsh
    pyenv/pyenv
  )

  p6_return_void
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
  code --install-extension FedericoVarela.pipenv-scripts
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
#  Depends:	 p6_file
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
  latest=$(pyenv install -l | grep '^ *3' | grep -v "[a-z]" | tail -1 | sed -e 's, *,,g')
  pyenv install -s $latest
  pyenv global $latest
  pyenv rehash

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::langs::nuke()
#
#  Depends:	 p6_git
#>
######################################################################
p6df::modules::python::langs::nuke() {

  # nuke the old one
  local previous
  previous=$(pyenv install -l | grep '^ *3' | grep -v "[a-z]" | tail -2 | head -1 | sed -e 's, *,,g')
  pyenv uninstall -f $previous

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::langs::pull()
#
#  Depends:	 p6_git
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::python::langs::pull() {

  (
    cd $P6_DFZ_SRC_DIR/pyenv/pyenv
    p6_git_p6_pull
  )

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
# Function: p6df::modules::python::pipenv::add()
#
#>
######################################################################
p6df::modules::python::pipenv::add() {

  p6df::core::prompt::line::add "p6_lang_prompt_info"
  p6df::core::prompt::line::add "p6_lang_envs_prompt_info"
  p6df::core::prompt::lang::line::add pip
}

######################################################################
#<
#
# Function: p6df::modules::python::langs::pipenv()
#
#  Depends:	 p6_pipenv
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
# Function: str str = p6_pip_env_prompt_info()
#
#  Returns:
#	str - str
#
#  Depends:	 p6_string
#  Environment:	 COMMANDLINE PIPENV_ACTIVE
#>
######################################################################
p6_pip_env_prompt_info() {

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

    str="pip=$env ($astr)"
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
#  Depends:	 p6_echo
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::python::init() {

  compdef _pipenv pipenv

  p6df::modules::python::pyenv::init "$P6_DFZ_SRC_DIR"
  p6df::modules::python::prompt::init

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::pyenv::init(dir)
#
#  Args:
#	dir -
#
#  Depends:	 p6_env p6_path p6_string
#  Environment:	 DISABLE_ENVS HAS_PYENV PYENV_ROOT
#>
######################################################################
p6df::modules::python::pyenv::init() {
  local dir="$1"

  if p6_string_blank "$DISABLE_ENVS"; then
    PYENV_ROOT=$dir/pyenv/pyenv
    local bin=$PYENV_ROOT/bin/pyenv
    if [ -x $bin ]; then
      p6_env_export "PYENV_ROOT" "$PYENV_ROOT"
      p6_env_export "HAS_PYENV" "1"
      p6_path_if "$PYENV_ROOT/bin"

      eval "$($bin init --path)"
      eval "$($bin init -)"
    fi
  fi

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::prompt::init()
#
#>
######################################################################
p6df::modules::python::prompt::init() {

  p6df::core::prompt::line::add "p6_lang_prompt_info"
  p6df::core::prompt::line::add "p6_lang_envs_prompt_info"
  p6df::core::prompt::lang::line::add py
}

######################################################################
#<
#
# Function: str str = p6_py_env_prompt_info()
#
#  Returns:
#	str - str
#
#  Depends:	 p6_string
#  Environment:	 P6_NL PYENV_ROOT PYTHON_PATH
#>
######################################################################
p6_py_env_prompt_info() {

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
#  Depends:	 p6_dir p6_env p6_string
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
}
