# shellcheck shell=bash
_pipenv() {
  eval $(env COMMANDLINE="${words[1, $CURRENT]}" _PIPENV_COMPLETE=complete-zsh pipenv)
}
