ifeq ($(OS),Windows_NT)
		OS_detected := Windows
else
		OS_detected := $(shell uname -s)
endif

all: install
.PHONY: install

install:
ifeq ($(OS_detected), Darwin)
		./scripts/macos.sh
else
		$(warning "$(OS_detected) is not yet supported!")
endif
