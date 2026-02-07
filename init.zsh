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
    p6m7g8-dotfiles/p6python
    matthiasha/zsh-uv-env
    astral-sh/uv
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

#  p6df::modules::vscode::extension::install ms-python.mypy-type-checker
#  p6df::modules::vscode::extension::install ms-python.pylint

  p6df::modules::vscode::extension::install ms-python.python
  # included above
  # p6df::modules::vscode::extension::install ms-python.vscode-pylance
  # p6df::modules::vscode::extension::install ms-python.vscode-python-envs
  # p6df::modules::vscode::extension::install ms-python.debugpy
  p6df::modules::vscode::extension::install ms-python.black-formatter
  p6df::modules::vscode::extension::install ms-python.isort
  p6df::modules::vscode::extension::install ms-python.flake8
  p6df::modules::vscode::extension::install the0807.uv-toolkit

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::vscodes::config()
#
#>
######################################################################
p6df::modules::python::vscodes::config() {

#  "mypy-type-checker.importStrategy": "fromEnvironment",

  cat <<'EOF'
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter"
  },
  "editor.codeActionsOnSave": {
    "source.organizeImports": "always"
  },
  "black-formatter.importStrategy": "fromEnvironment",
  "flake8.importStrategy": "fromEnvironment",
  "python.analysis.typeCheckingMode": "basic",
  "python.languageServer": "Pylance",
  "python.terminal.executeInFileDir": true,
  "python.testing.pytestEnabled": true
EOF

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::python::pyproject::toml()
#
#>
######################################################################
p6df::modules::python::pyproject::toml() {

  cat <<'EOF'
[project]
name = "p6-template-uv"
dynamic = ["version"]
requires-python = "==3.14.2"
dependencies = [
  "docopt",
]

[dependency-groups]
dev = [
  "bandit",
  "black",
  "codespell",
  "coverage",
  "detect-secrets",
  "flake8",
  "isort",
  "pip-audit",
  "pre-commit",
  "pydocstyle",
  "pylint",
  "pymarkdownlnt",
  "pyre-check",
  "pyre-extensions",
  "pytest",
  "pytest-cov",
  "shellcheck-py",
  "yamllint",
]

[tool.setuptools]
include-package-data = false

[tool.uv]
index-url = "https://pypi.org/simple"

[tool.black]
line-length = 120

[tool.isort]
profile = "black"
line_length = 120

[tool.flake8]
max-line-length = 120
extend-ignore = ["E203"]

[tool.pylint.format]
max-line-length = 120

[tool.pytest.ini_options]
testpaths = ["tests"]
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
