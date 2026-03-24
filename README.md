# Ligolo-ng with Web UI

Build ligolo-ng proxy and agent binaries with the embedded web UI baked in. The Dockerfile clones the latest [ligolo-ng](https://github.com/nicocha30/ligolo-ng) and [ligolo-ng-web](https://github.com/nicocha30/ligolo-ng-web), builds the frontend, and compiles static binaries for multiple platforms.

## Requirements

- Docker

## Usage

```bash
make build
```

Binaries will be in `./build/`. Run `make clean` to remove them.

## Install as a Service

```bash
make install
```

This builds the binaries and installs ligolo-ng proxy as a systemd service. After installation, run the proxy once manually to generate the config file, then start the service:

```bash
cd /etc/ligolo-ng
sudo ./ligolo-proxy -selfcert
sudo systemctl enable ligolo-ng
sudo systemctl start ligolo-ng
```
