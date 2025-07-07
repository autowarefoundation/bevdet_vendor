# SPDX-FileCopyrightText: Copyright (c) 2021 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Copyright 2024 AutoCore, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.14.0)
project(bevdet_vendor)

add_compile_options(-std=c++17)
set(CMAKE_CXX_FLAGS_RELEASE "-Wno-deprecated-declarations -O3")
set(CMAKE_BUILD_TYPE "RELEASE")

find_package(ament_cmake REQUIRED)
find_package(cudnn_cmake_module REQUIRED)
find_package(tensorrt_cmake_module REQUIRED)
find_package(rclcpp REQUIRED)
find_package(yaml-cpp REQUIRED)
find_package(Eigen3 REQUIRED)

find_package(CUDA)
find_package(CUDAToolkit)
find_package(CUDNN)
find_package(TENSORRT)
if(NOT (CUDAToolkit_FOUND AND CUDNN_FOUND AND TENSORRT_FOUND))
  message(WARNING "cuda, cudnn, tensorrt libraries are not found")
  return()
endif()

set(bevdet_source_files
  src/bevdet.cpp

  src/preprocess.cu
  src/iou3d_nms.cu
  src/postprocess.cu
  src/data.cpp
  src/cpu_jpegdecoder.cpp
  src/nvjpegdecoder.cpp

  src/preprocess_plugin.cu
  src/bevpool_plugin.cu
  src/alignbev_plugin.cu
  src/gatherbev_plugin.cu
  src/precision_config.cpp
)

cuda_add_library(${PROJECT_NAME} SHARED
  ${bevdet_source_files}
)

target_include_directories(
  ${PROJECT_NAME} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include/${PROJECT_NAME}>
  ${YAML_CPP_INCLUDE_DIRS}
  ${EIGEN3_INCLUDE_DIRS}
)

target_link_libraries(
  ${PROJECT_NAME}
  CUDA::cudart
  yaml-cpp
  ${NVINFER}
  ${NVONNXPARSER}
  ${TENSORRT_LIBRARIES}
  ${CUDA_LIBRARIES}
  ${CUBLAS_LIBRARIES}
  ${CUDNN_LIBRARY}
)

set_target_properties(${PROJECT_NAME}
  PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
)

install(
  DIRECTORY include/
  DESTINATION include/${PROJECT_NAME}
)

install(
  TARGETS ${PROJECT_NAME}
  EXPORT export_${PROJECT_NAME}
)

ament_export_targets(export_${PROJECT_NAME})

ament_export_dependencies(
  "CUDA"
  "CUDAToolkit"
  "cudnn_cmake_module"
  "CUDNN"
  "rclcpp"
  "tensorrt_cmake_module"
  "TENSORRT"
)

ament_package()