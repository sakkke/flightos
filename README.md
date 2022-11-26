# Flight OS
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/sakkke/flightos?include_prereleases&style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/sakkke/flightos?style=for-the-badge)
![GitHub issues](https://img.shields.io/github/issues-raw/sakkke/flightos?style=for-the-badge)
![GitHub pull requests](https://img.shields.io/github/issues-pr/sakkke/flightos?style=for-the-badge)
![GitHub](https://img.shields.io/github/license/sakkke/flightos?style=for-the-badge)
![CalVer format](https://img.shields.io/badge/calver-YYYY.MM.MICRO-22bfda.svg?style=for-the-badge)

**NB: WIP description!**

Flight OS is one of Arch Linux distros.
**Out of the box**!
It values **fast**, **simple**, and **maintainable**.
It has tiling shell and very comfortable fuzzy finder based UI, so they helps to shorten search time and to save time.
Flight OS and its all apps are always free and open source!
Minimum graphical app set is here.
It includes a web browser and a terminal only.
Web browser is very useful in the world.
It is a bridge of the internet.
Flight OS gives hyper Web integration!
Terminal based apps connects some data connecting seamlessly and supports 3D UI.
In that, you could find new things.
Flight OS is super simple!
Installation method is one-line command only, and initialization is also crazy easy.
Want to save your personalization?
Yes, Flight OS is **customizable** and **extendable**!
Flight OS supports applying configurations of system and dotfiles.
Base system uses Arch Linux, so the system is always latest every day.
Can't boot?
Want to bring back to past?
You can initialize or bring back to past with Flight OS installer in few minutes.
Want to try Flight OS?
Let's find your destination with Flight OS!

## Fastest Release Cycle
There is the fastest release cycle.
Upgrade is always easy.

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
    - [Philosophies](#philosophies)
    - [Development](#development)
        - [Build Dependencies](#build-dependencies)
        - [Build](#build)
    - [Contributing](#contributing)
    - [License](#license)
    - [Footer](#footer)

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

## Philosophies

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
