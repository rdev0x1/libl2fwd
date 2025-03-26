# SPDX-License-Identifier: BSD-3-Clause
# Copyright(c) 2010-2014 Intel Corporation

# binary name
APP = l2fwd

# all source are stored in SRCS-y
SRCS-y := main.c

PKGCONF ?= pkg-config

# List of targets that require a DPDK environment
BUILD_TARGETS := all lib static shared

# If no user-specified goals => it's effectively running 'all',
# so we do the DPDK check. Otherwise, we filter against BUILD_TARGETS.
ifeq ($(MAKECMDGOALS),)
  NEED_DPDK_CHECK := 1
else
  ifneq ($(filter $(BUILD_TARGETS),$(MAKECMDGOALS)),)
    NEED_DPDK_CHECK := 1
  else
    NEED_DPDK_CHECK := 0
  endif
endif

# If building is needed, check for DPDK dependencies
ifeq ($(NEED_DPDK_CHECK),1)
  ifneq ($(shell $(PKGCONF) --exists libdpdk && echo 0),0)
    $(error "No installation of DPDK found")
  endif
endif

all: shared
.PHONY: shared static format
shared: build/$(APP)-shared
	ln -sf $(APP)-shared build/$(APP)
static: build/$(APP)-static
	ln -sf $(APP)-static build/$(APP)

PC_FILE := $(shell $(PKGCONF) --path libdpdk 2>/dev/null)
CFLAGS += -O3 $(shell $(PKGCONF) --cflags libdpdk)
# Add flag to allow experimental API as l2fwd uses rte_ethdev_set_ptype API
CFLAGS += -DALLOW_EXPERIMENTAL_API
LDFLAGS_SHARED = $(shell $(PKGCONF) --libs libdpdk)
LDFLAGS_STATIC = $(shell $(PKGCONF) --static --libs libdpdk)

ifeq ($(MAKECMDGOALS),static)
# check for broken pkg-config
ifeq ($(shell echo $(LDFLAGS_STATIC) | grep 'whole-archive.*l:lib.*no-whole-archive'),)
$(warning "pkg-config output list does not contain drivers between 'whole-archive'/'no-whole-archive' flags.")
$(error "Cannot generate statically-linked binaries with this version of pkg-config")
endif
endif

build/$(APP)-shared: $(SRCS-y) Makefile $(PC_FILE) | build
	$(CC) $(CFLAGS) $(SRCS-y) -o $@ $(LDFLAGS) $(LDFLAGS_SHARED)

build/$(APP)-static: $(SRCS-y) Makefile $(PC_FILE) | build
	$(CC) $(CFLAGS) $(SRCS-y) -o $@ $(LDFLAGS) $(LDFLAGS_STATIC)

build:
	@mkdir -p $@

format:
	@for f in $(SRCS-y); do \
		clang-format -style=file:.clang-format -i $$f; \
	done

clean:
	rm -f build/$(APP) build/$(APP)-static build/$(APP)-shared
	test -d build && rmdir -p build || true
