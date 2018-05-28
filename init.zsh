p6df::modules::python::version() { echo "0.0.1" }
p6df::modules::python::deps()    {
	ModuleDeps=()
}

p6df::modules::python::external::brew() {
}

p6df::modules::python::init() {

  p6df::modules::python::pyenv::init
}

p6df::modules::python::pyenv::init() {
    [ -n "$DISABLE_ENVS" ] && return

    PYENV_ROOT=/Users/pgollucci/.local/share/pyenv/pyenv

    if [ -x $PYENV_ROOT/bin/pyenv ]; then
      export PYENV_ROOT
      export HAS_PYENV=1
      export PYENV_VIRTUALENV_DISABLE_PROMPT=1

      p6dfz::util::path_if $PYENV_ROOT/bin
      eval "$(pyenv init - zsh)"
    fi
}

p6df::prompt::python::line() {

  env_version "py"
}
