# shellcheck shell=bash
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
