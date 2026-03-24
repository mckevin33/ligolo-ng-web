OUTPUT_DIR := ./build

.PHONY: all build clean

all: build

build:
	mkdir -p $(OUTPUT_DIR)
	docker build --target binaries --output type=local,dest=$(OUTPUT_DIR) .
	@echo ""
	@echo "Build complete. Binaries in $(OUTPUT_DIR)/"
	@ls -lh $(OUTPUT_DIR)/

clean:
	rm -rf $(OUTPUT_DIR)
