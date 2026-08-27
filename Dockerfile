# syntax=docker/dockerfile:1
#
# Build ligolo-ng proxy + agent with the embedded Web UI, the upstream way:
#   - clone ligolo-ng at a pinned release tag WITH its submodule (web/ligolo-ng-web)
#   - `go generate ./web` runs the author's directives:
#       npm install / npm run build-ligolo  ->  web/dist
#     which is then baked in via `//go:embed dist` (see web/web.go upstream)
# This keeps us in lock-step with upstream instead of hand-wiring the web build.

ARG LIGOLO_VERSION=v0.9.1

FROM golang:1.27-alpine AS builder

# git + submodules, node/npm for the web build (invoked by `go generate`)
RUN apk add --no-cache git nodejs npm

ARG LIGOLO_VERSION
WORKDIR /src
RUN git clone --branch "${LIGOLO_VERSION}" --depth 1 \
      --recurse-submodules --shallow-submodules \
      https://github.com/nicocha30/ligolo-ng.git .

RUN go mod download

# Author's way: build the embedded Web UI into web/dist (//go:embed dist)
RUN go generate ./web

# Cross-compile the matrix. CGO disabled -> fully static binaries.
RUN set -e && \
    LDFLAGS="-s -w -X main.version=${LIGOLO_VERSION} -extldflags \"-static\"" && \
    for pair in \
      "linux   amd64 ligolo-proxy-linux-amd64        cmd/proxy/main.go" \
      "linux   arm64 ligolo-proxy-linux-arm64        cmd/proxy/main.go" \
      "windows amd64 ligolo-proxy-windows-amd64.exe  cmd/proxy/main.go" \
      "windows 386   ligolo-proxy-windows-386.exe    cmd/proxy/main.go" \
      "linux   amd64 ligolo-agent-linux-amd64        cmd/agent/main.go" \
      "linux   386   ligolo-agent-linux-386          cmd/agent/main.go" \
      "linux   arm64 ligolo-agent-linux-arm64        cmd/agent/main.go" \
      "windows amd64 ligolo-agent-windows-amd64.exe  cmd/agent/main.go" \
      "windows 386   ligolo-agent-windows-386.exe    cmd/agent/main.go" \
    ; do \
      set -- $pair; \
      echo "  building $3 ($1/$2)"; \
      CGO_ENABLED=0 GOOS=$1 GOARCH=$2 \
        go build -trimpath -ldflags "$LDFLAGS" -o /out/$3 $4; \
    done

FROM scratch AS binaries
COPY --from=builder /out/ /
