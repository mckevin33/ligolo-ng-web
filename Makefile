OUTPUT_DIR := ./build

.PHONY: all build install clean

all: build

build:
	mkdir -p $(OUTPUT_DIR)
	docker build --target binaries --output type=local,dest=$(OUTPUT_DIR) .
	@echo ""
	@echo "Build complete. Binaries in $(OUTPUT_DIR)/"
	@ls -lh $(OUTPUT_DIR)/

install: build
	sudo bash install.sh

clean:
	rm -rf $(OUTPUT_DIR)
