# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::python::pyenv::latest()
#
#>
######################################################################
p6df::modules::python::pyenv::latest() {

  pyenv install -l | p6_filter_row_select "^ *3" | p6_filter_row_exclude "[a-z]" | p6_filter_row_last "1" | p6_filter_spaces_strip
}

######################################################################
#<
#
# Function: p6df::modules::python::pyenv::latest::installed()
#
#>
######################################################################
p6df::modules::python::pyenv::latest::installed() {

  pyenv install -l | p6_filter_row_select "^ *3" | p6_filter_row_exclude "[a-z]" | p6_filter_row_from_end "2" | p6_filter_spaces_strip
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
