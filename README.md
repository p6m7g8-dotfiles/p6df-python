# P6's POSIX.2: p6df-python

## Table of Contents

- [Badges](#badges)
- [Summary](#summary)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [Usage](#usage)
  - [Functions](#functions)
- [Hierarchy](#hierarchy)
- [Author](#author)

## Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)

## Summary

TODO: Add a short summary of this module.

## Contributing

- [How to Contribute](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CONTRIBUTING.md>)

## Code of Conduct

- [Code of Conduct](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CODE_OF_CONDUCT.md>)

## Usage

### Functions

#### p6df-python

##### p6df-python/init.zsh

- `p6df::modules::python::deps()`
- `p6df::modules::python::external::brews()`
- `p6df::modules::python::home::symlinks()`
- `p6df::modules::python::mcp()`
- `p6df::modules::python::path::init(_module, _dir)`
  - Args:
    - _module
    - _dir
- `p6df::modules::python::vscodes()`
- `p6df::modules::python::vscodes::config()`
- `str str = p6df::modules::python::prompt::lang()`
- `str str = p6df::modules::python::prompt::system()`

#### p6df-python/lib

##### p6df-python/lib/pyproject.zsh

- `p6df::modules::python::pyproject::toml()`

##### p6df-python/lib/uv.zsh

- `p6_python_uv_tool_install(pkg)`
  - Args:
    - pkg

## Hierarchy

```text
.
├── init.zsh
├── lib
│   ├── pyproject.zsh
│   └── uv.zsh
├── README.md
└── share

3 directories, 4 files
```

## Author

Philip M. Gollucci <pgollucci@p6m7g8.com>
