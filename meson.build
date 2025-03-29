# SPDX-License-Identifier: BSD-3-Clause
# Copyright(c) 2017 Intel Corporation

# meson file, for building this example as part of a main DPDK build.
#
# To build this example as a standalone application with an already-installed
# DPDK instance, use 'make'

# Enable experimental API flag as l2fwd uses rte_ethdev_set_ptype API

project('l2fwd', 'c')

allow_experimental_apis = true

dpdk_dep = dependency('libdpdk', required: true)

cflags = ['-DALLOW_EXPERIMENTAL_API']

libl2fwd_static = static_library('l2fwd',
    sources: ['l2fwd.c'],
    dependencies: dpdk_dep,
    c_args: cflags
)

libl2fwd_shared = shared_library('l2fwd',
    sources: ['l2fwd.c'],
    dependencies: dpdk_dep,
    c_args: cflags
)

executable('main', 'main.c',
    link_with: libl2fwd_static,
    dependencies: dpdk_dep,
    c_args: cflags
)
