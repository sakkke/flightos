# Flight OS
An Arch Linux distro.

## Features
- **One-line installation from Archiso**: the installer is written in [V](https://github.com/vlang/v).
- **Fuzzy finder based UI**: the installer uses [fzf](https://github.com/junegunn/fzf).

## Dependencies
- [vfzf](https://github.com/sakkke/vfzf): a wrapper for [fzf](https://github.com/junegunn/fzf).

## Setup

One-liner:
```shell
curl -s https://raw.githubusercontent.com/sakkke/flightos/main/scripts/setup.sh | sh
```

## Build

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

## License

MIT
