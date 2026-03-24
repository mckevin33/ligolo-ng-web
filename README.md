# Ligolo-ng with Web UI

Build ligolo-ng proxy and agent binaries with the embedded web UI baked in. The Dockerfile clones the latest [ligolo-ng](https://github.com/nicocha30/ligolo-ng) and [ligolo-ng-web](https://github.com/nicocha30/ligolo-ng-web), builds the frontend, and compiles static binaries for multiple platforms.

## Requirements

- Docker

## Usage

```bash
make build
```

Binaries will be in `./build/`. Run `make clean` to remove them.
