# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(matrix_multiplyer_ffi_library VERSION 0.0.1 LANGUAGES C)

add_library(matrix_multiplyer_ffi SHARED
  "matrix_multiplyer_ffi.c"
)

set_target_properties(matrix_multiplyer_ffi PROPERTIES
  PUBLIC_HEADER matrix_multiplyer_ffi.h
  OUTPUT_NAME "matrix_multiplyer_ffi"
)

target_compile_definitions(matrix_multiplyer_ffi PUBLIC DART_SHARED_LIB)
