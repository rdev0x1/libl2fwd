# SPDX-License-Identifier: BSD-3-Clause
# Copyright(c) 2010-2014 Intel Corporation

# library name
APP = l2fwd

# all source are stored in SRCS-y
SRCS-y := l2fwd.c
TEST_SRCS-y := test_main.c
HDRS-y := libl2fwd.h

PKGCONF ?= pkg-config

# List of targets that require a DPDK environment
BUILD_TARGETS := all lib static shared test

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

CFLAGS += -O3 $(shell $(PKGCONF) --cflags libdpdk) -fPIC -DALLOW_EXPERIMENTAL_API
LDFLAGS_SHARED = $(shell $(PKGCONF) --libs libdpdk)
LDFLAGS_STATIC = $(shell $(PKGCONF) --static --libs libdpdk)

.PHONY: all lib static shared clean test format-c format-h format

all: lib test

lib: shared static

static: build/lib$(APP).a

shared: build/lib$(APP).so

build/lib$(APP).a: $(SRCS-y) $(HDRS-y) Makefile | build
	$(CC) $(CFLAGS) -c $(SRCS-y) -o build/$(APP).o
	ar rcs $@ build/$(APP).o

build/lib$(APP).so: $(SRCS-y) $(HDRS-y) Makefile | build
	$(CC) $(CFLAGS) -shared $(SRCS-y) -o $@ $(LDFLAGS_SHARED)

test: build/testl2fwd

build/testl2fwd: $(TEST_SRCS-y) build/lib$(APP).a $(HDRS-y) Makefile | build
	$(CC) $(CFLAGS) $(TEST_SRCS-y) -o $@ build/lib$(APP).a $(LDFLAGS_STATIC)

build:
	@mkdir -p $@

format-c:
	@for f in $(SRCS-y) $(TEST_SRCS-y); do \
		clang-format -style=file:.clang-format -i $$f; \
	done

format-h:
	@for f in $(HDRS-y); do \
		clang-format -style=file:.clang-format-h -i $$f; \
	done

format: format-c format-h

clean:
	rm -rf build
