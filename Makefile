DOCKER ?= docker
VEXE := $(DOCKER) run --rm -v "$${LOCAL_WORKSPACE_FOLDER:-$$PWD}":/src flightos-build v
VFLAGS ?=

.PHONY: all build build-container-build build-container-vlang build-force clean clean-container dev setup

all: build

build: setup
	@$(VEXE) $(VFLAGS) -o flightos .

check: setup
	@$(VEXE) $(VFLAGS) test .

clean:
	@$(RM) flightos
	@if docker inspect --type image flightos-build > /dev/null 2>&1; then \
		$(DOCKER) image rm flightos-build; \
	fi
	@if docker inspect --type image flightos-vlang > /dev/null 2>&1; then \
		$(DOCKER) image rm flightos-vlang; \
	fi

dev: setup
	@$(DOCKER) run --rm -it -v "$${LOCAL_WORKSPACE_FOLDER:-$$PWD}":/src flightos-build

setup:
	@if ! docker inspect --type image flightos-build > /dev/null 2>&1; then \
		$(DOCKER) build --build-arg VLANG_UID="$(shell id -u)" -t flightos-vlang ./containers/vlang; \
		$(DOCKER) build -t flightos-build -f ./containers/build/Dockerfile .; \
	fi
