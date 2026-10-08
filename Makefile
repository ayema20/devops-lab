SRC_DIR := src
OUT_DIR := out

SOURCES := $(wildcard $(SRC_DIR)/*.txt)
OUTPUTS := $(patsubst $(SRC_DIR)/%.txt,$(OUT_DIR)/%.txt,$(SOURCES))

.PHONY: all build test check clean ci

all: build test

build: $(OUTPUTS)

$(OUT_DIR)/%.txt: $(SRC_DIR)/%.txt | $(OUT_DIR)
	tr '[:lower:]' '[:upper:]' < $< > $@

$(OUT_DIR):
	mkdir -p $@

check:
	@if [ ! -d "$(SRC_DIR)" ]; then \
		echo "ERROR: source directory '$(SRC_DIR)' is missing"; \
		exit 1; \
	elif [ -z "$(SOURCES)" ]; then \
		echo "ERROR: no .txt files found in $(SRC_DIR)"; \
		exit 1; \
	else \
		echo "CHECK OK: found $(words $(SOURCES)) .txt source file(s)"; \
	fi

test: build
	@if grep -R -n '[[:lower:]]' $(OUT_DIR)/*.txt; then \
		echo "TEST FAILED: lowercase letters remain in output"; \
		exit 1; \
	else \
		echo "TEST PASSED: all output is uppercase"; \
	fi

clean:
	rm -rf $(OUT_DIR)

ci: clean check test
