OUTPUT_DIR := ./build

# Pinned upstream ligolo-ng release tag. Bump here to build a newer version:
#   make build LIGOLO_VERSION=v0.9.2
LIGOLO_VERSION ?= v0.9.1

.PHONY: all build install clean

all: build

build:
	mkdir -p $(OUTPUT_DIR)
	docker build --target binaries \
		--build-arg LIGOLO_VERSION=$(LIGOLO_VERSION) \
		--output type=local,dest=$(OUTPUT_DIR) .
	@echo ""
	@echo "Build complete ($(LIGOLO_VERSION)). Binaries in $(OUTPUT_DIR)/"
	@ls -lh $(OUTPUT_DIR)/

install: build
	sudo bash install.sh

clean:
	rm -rf $(OUTPUT_DIR)
