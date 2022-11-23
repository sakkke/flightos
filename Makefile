DOCKER ?= docker

.PHONY: all build build-container-build build-container-vlang build-force clean clean-container dev setup

all: build

build:
	@$(MAKE) setup
	@$(DOCKER) run --rm -v "$${LOCAL_WORKSPACE_FOLDER:-$$PWD}":/src flightos-build v -prod -o flightos .

build-container-build: build-container-vlang
	@$(DOCKER) build -t flightos-build -f ./containers/build/Dockerfile .

build-container-vlang:
	@$(DOCKER) build --build-arg VLANG_UID="$(shell id -u)" -t flightos-vlang ./containers/vlang

build-force: build-container-vlang build-container-build flightos

check:
	@$(MAKE) setup
	@$(DOCKER) run --rm -v "$${LOCAL_WORKSPACE_FOLDER:-$$PWD}":/src flightos-build v test .

clean:
	@$(RM) flightos
	@if docker inspect --type image flightos-build > /dev/null 2>&1; then \
		$(MAKE) clean-container-build; \
	fi
	@if docker inspect --type image flightos-vlang > /dev/null 2>&1; then \
		$(MAKE) clean-container-vlang; \
	fi

clean-container-build:
	@$(DOCKER) image rm flightos-build

clean-container-vlang:
	@$(DOCKER) image rm flightos-vlang

dev:
	@$(MAKE) setup
	@$(DOCKER) run --rm -it -v "$${LOCAL_WORKSPACE_FOLDER:-$$PWD}":/src flightos-build

setup:
	@if ! docker inspect --type image flightos-build > /dev/null 2>&1; then \
		$(MAKE) build-container-build; \
	fi
