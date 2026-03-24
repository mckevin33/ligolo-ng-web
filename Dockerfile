FROM node:20-alpine AS web-builder

RUN apk add --no-cache git

WORKDIR /src
RUN git clone --depth 1 https://github.com/nicocha30/ligolo-ng-web.git .
RUN npm ci && npm run build

FROM golang:1.24-alpine AS go-builder

RUN apk add --no-cache git gcc musl-dev

WORKDIR /src
RUN git clone --depth 1 https://github.com/nicocha30/ligolo-ng.git .
RUN go mod download

COPY --from=web-builder /src/dist/ /src/web/dist/

RUN set -e && \
    for pair in \
      "linux   amd64 ligolo-proxy-linux-amd64       cmd/proxy/main.go" \
      "linux   arm64 ligolo-proxy-linux-arm64        cmd/proxy/main.go" \
      "windows amd64 ligolo-proxy-windows-amd64.exe  cmd/proxy/main.go" \
      "windows 386   ligolo-proxy-windows-386.exe    cmd/proxy/main.go" \
      "linux   amd64 ligolo-agent-linux-amd64        cmd/agent/main.go" \
      "linux   386   ligolo-agent-linux-386           cmd/agent/main.go" \
      "linux   arm64 ligolo-agent-linux-arm64        cmd/agent/main.go" \
      "windows amd64 ligolo-agent-windows-amd64.exe  cmd/agent/main.go" \
      "windows 386   ligolo-agent-windows-386.exe    cmd/agent/main.go" \
    ; do \
      set -- $pair; \
      CGO_ENABLED=0 GOOS=$1 GOARCH=$2 \
        go build -ldflags '-w -extldflags "-static"' \
        -o /out/$3 $4; \
    done

FROM scratch AS binaries
COPY --from=go-builder /out/ /
