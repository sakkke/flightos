# Flight OS
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/sakkke/flightos?include_prereleases&style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/sakkke/flightos?style=for-the-badge)
![GitHub issues](https://img.shields.io/github/issues-raw/sakkke/flightos?style=for-the-badge)
![GitHub pull requests](https://img.shields.io/github/issues-pr/sakkke/flightos?style=for-the-badge)
![GitHub](https://img.shields.io/github/license/sakkke/flightos?style=for-the-badge)

An Arch Linux distro.

## Features
- **One-line installation from Archiso**: the installer is written in [V](https://github.com/vlang/v).
- **Fuzzy finder based UI**: the installer uses [fzf](https://github.com/junegunn/fzf).

## Installation Demo
[WIP](https://github.com/sakkke/flightos/issues/91)

## Table of Contents

- [Flight OS](#flight-os)
    - [Features](#features)
    - [Installation Demo](#installation-demo)
    - [Table of Contents](#table-of-contents)
    - [Setup](#setup)
    - [Development](#development)
        - [Build Dependencies](#build-dependencies)
        - [Build](#build)
    - [Contributing](#contributing)
    - [License](#license)

## Setup
[(Back to top)](#table-of-contents)

One-liner:
```shell
curl -s https://raw.githubusercontent.com/sakkke/flightos/main/scripts/setup.sh | sh
```

Help:
```shell
curl -s https://raw.githubusercontent.com/sakkke/flightos/main/scripts/setup.sh | sh -s -- -h
```

## Development
[(Back to top)](#table-of-contents)

### Build Dependencies
[(Back to top)](#table-of-contents)

- [vfzf](https://github.com/sakkke/vfzf): a wrapper for [fzf](https://github.com/junegunn/fzf).

### Build
[(Back to top)](#table-of-contents)

Requirements:
- `docker`

Build builder images and the binary:
```shell
make
```

Test:
```shell
make check
```

Enter disposable dev container:
```shell
make dev
```

Remove the binary and builder images:
```shell
make clean
```

## Contributing
[(Back to top)](#table-of-contents)

- [CODE_OF_CONDUCT.md](https://github.com/sakkke/flightos/blob/main/CODE_OF_CONDUCT.md)
- [CONTRIBUTING.md](https://github.com/sakkke/flightos/blob/main/CONTRIBUTING.md)

## License
[(Back to top)](#table-of-contents)

[MIT](https://github.com/sakkke/flightos/blob/main/LICENSE)

## Footer
[(Back to top)](#table-of-contents)

<a href="https://www.buymeacoffee.com/sakkke" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-green.png" alt="Buy Me A Coffee" height="41" width="174"></a>
