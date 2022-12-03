AWK ?= awk
CAT ?= cat
DOCKER ?= docker
FALSE ?= false
GIT ?= git
GREP ?= grep
VEXE := $(DOCKER) run --rm -v "$${LOCAL_WORKSPACE_FOLDER:-$$PWD}":/src flightos-build v
VFLAGS ?=
MKDIR_P := mkdir -p
RM_RF := rm -rf
SED ?= sed
WC ?= wc
XARGS ?= xargs
ver ?=

.PHONY: all build check clean dev draft fmt loc setup upgrade

all: build

build: setup
	$(MKDIR_P) ./dist
	$(VEXE) $(VFLAGS) -o ./dist/flightos ./cmd/flightos

check: setup
	$(VEXE) $(VFLAGS) test ./cmd/flightos

clean:
	$(RM_RF) ./dist
	if $(DOCKER) inspect --type image flightos-build > /dev/null 2>&1; then \
		$(DOCKER) image rm flightos-build; \
	fi
	if $(DOCKER) inspect --type image flightos-vlang > /dev/null 2>&1; then \
		$(DOCKER) image rm flightos-vlang; \
	fi

dev: setup
	$(DOCKER) run --rm -it -v "$${LOCAL_WORKSPACE_FOLDER:-$$PWD}":/src flightos-build

fmt: setup
	$(GIT) status --porcelain | $(AWK) '{ if ($$1 == "??" || $$1 == "A" || $$1 == "M") print $$2 }' | $(GREP) '.v$$' | $(XARGS) -r $(VEXE) fmt -w

loc:
	$(GIT) ls-files | $(GREP) '.v$$' | $(XARGS) $(WC) -l

release: build check
	if [ "$$(git status --porcelain | wc -l)" != 0 ]; then \
		$(FALSE); \
	fi
	if [ -z "$(ver)" ]; then \
		$(FALSE); \
	fi
	$(SED) -i "s/$$($(CAT) ./version.txt)/$(ver)/" ./cmd/flightos/flightos.v ./v.mod ./version.txt
	$(GIT) add ./cmd/flightos/flightos.v ./v.mod ./version.txt
	$(GIT) commit -m "chore(release): $(ver)"
	$(GIT) tag "$(ver)"

setup:
	if ! $(DOCKER) inspect --type image flightos-build > /dev/null 2>&1; then \
		$(DOCKER) build --build-arg VLANG_UID="$(shell id -u)" -t flightos-vlang ./containers/vlang; \
		$(DOCKER) build -t flightos-build -f ./containers/build/Dockerfile .; \
	fi
