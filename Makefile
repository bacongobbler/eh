NAME            ?= eh
TARGETS         = darwin/amd64 linux/amd64 linux/386 linux/arm windows/amd64
DIST_DIRS       = find * -type d -exec

# go option
GO        ?= go
TAGS      := kqueue
TESTS     := .
TESTFLAGS :=
LDFLAGS   :=
GOFLAGS   :=
BINDIR    := $(CURDIR)/bin
BINARIES  := eh 

# Required for globs to work correctly
SHELL=/bin/bash

.PHONY: all
all: build

.PHONY: build
build:
	GOBIN=$(BINDIR) $(GO) install $(GOFLAGS) -tags '$(TAGS)' -ldflags '$(LDFLAGS)' github.com/bacongobbler/eh/cmd/...

# usage: make clean build-cross dist APP=draft|draftd VERSION=v2.0.0-alpha.3
.PHONY: build-cross
build-cross: LDFLAGS += -extldflags "-static"
build-cross:
	CGO_ENABLED=0 gox -output="_dist/{{.OS}}-{{.Arch}}/{{.Dir}}" -osarch='$(TARGETS)' $(GOFLAGS) -tags '$(TAGS)' -ldflags '$(LDFLAGS)' github.com/bacongobbler/eh/cmd/$(NAME)

.PHONY: dist
dist:
	( \
		cd _dist && \
		$(DIST_DIRS) cp ../LICENSE {} \; && \
		$(DIST_DIRS) cp ../README.md {} \; && \
		$(DIST_DIRS) tar -zcf ${NAME}-${VERSION}-{}.tar.gz {} \; \
	)

.PHONY: checksum
checksum:
	for f in _dist/*.gz ; do \
		shasum -a 256 "$${f}"  | awk '{print $$1}' > "$${f}.sha256" ; \
	done

.PHONY: clean
clean:
	-rm bin/*
	-rm -rf _dist/

HAS_GOX := $(shell command -v gox;)

.PHONY: bootstrap
bootstrap:
ifndef HAS_GOX
	go get -u github.com/mitchellh/gox
endif
