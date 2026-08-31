# SPDX-FileCopyrightText: Copyright 2026 The Autoware Foundation
# SPDX-License-Identifier: Apache-2.0

# CUDA 13 moved the CCCL headers (Thrust, CUB, libcu++) to include/cccl/.
# Only nvcc adds that directory to its include path. The CCCL CMake config
# is outside the default search path, so find_package needs the hints.
# find_package searches the hints after CCCL_ROOT and CMAKE_PREFIX_PATH but
# before the system prefixes, so the toolkit config wins over a system copy
# and explicit user overrides still win over the hints.

find_package(CUDAToolkit REQUIRED)
find_package(CCCL CONFIG REQUIRED HINTS
  "${CUDAToolkit_LIBRARY_DIR}/cmake"
  "${CUDAToolkit_TARGET_DIR}/lib64/cmake"
  "${CUDAToolkit_TARGET_DIR}/lib/cmake")
