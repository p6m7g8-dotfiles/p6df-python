# shellcheck shell=bash
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
# Function: p6df::modules::python::langs::pull()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::python::langs::pull() {

  p6_run_dir "$P6_DFZ_SRC_DIR/pyenv/pyenv" p6_git_cli_pull_rebase_autostash_ff_only

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::langs::whls()
#
#>
######################################################################
p6df::modules::python::langs::whls() {

  Whls=(
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
    "pydantic"
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

  # @Whls
  p6df::modules::python::langs::whls

  local whl
  for wheel in $Whls[@]; do
    pipenv install $wheel
  done

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::langs::poetry()
#
#>
######################################################################
p6df::modules::python::langs::poetry() {

  curl -sSL https://install.python-poetry.org | python -

  p6_return_void
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

  # @Whls
  p6df::modules::python::langs::whls

  local whl
  for wheel in $Whls[@]; do
    pip install $wheel
  done
  pyenv rehash

  p6_return_void
}
