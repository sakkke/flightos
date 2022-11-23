DOCKER ?= docker
VEXE := $(DOCKER) run --rm -v "$${LOCAL_WORKSPACE_FOLDER:-$$PWD}":/src flightos-build v
VFLAGS ?=
MKDIR_P := mkdir -p
RM_RF := rm -rf

.PHONY: all build check clean dev setup

all: build

build: setup
	$(MKDIR_P) ./dist
	$(VEXE) $(VFLAGS) -o ./dist/flightos ./cmd/flightos

check: setup
	$(VEXE) $(VFLAGS) test ./cmd/flightos

clean:
	$(RM_RF) ./dist
	if docker inspect --type image flightos-build > /dev/null 2>&1; then \
		$(DOCKER) image rm flightos-build; \
	fi
	if docker inspect --type image flightos-vlang > /dev/null 2>&1; then \
		$(DOCKER) image rm flightos-vlang; \
	fi

dev: setup
	$(DOCKER) run --rm -it -v "$${LOCAL_WORKSPACE_FOLDER:-$$PWD}":/src flightos-build

setup:
	if ! docker inspect --type image flightos-build > /dev/null 2>&1; then \
		$(DOCKER) build --build-arg VLANG_UID="$(shell id -u)" -t flightos-vlang ./containers/vlang; \
		$(DOCKER) build -t flightos-build -f ./containers/build/Dockerfile .; \
	fi
