##===----------------------------------------------------------------------===##
##
## This source file is part of the Swift open source project
##
## Copyright (c) 2024 Apple Inc. and the Swift project authors
## Licensed under Apache License v2.0
##
## See LICENSE.txt for license information
## See CONTRIBUTORS.md for the list of Swift project authors
##
## SPDX-License-Identifier: Apache-2.0
##
##===----------------------------------------------------------------------===##

cmake_minimum_required(VERSION 3.24)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)

if(POLICY CMP0156)
    # Deduplicate linked libraries where appropriate
    cmake_policy(SET CMP0156 NEW)
endif()

if(POLICY CMP0157)
    if(CMAKE_HOST_SYSTEM_NAME STREQUAL Windows AND CMAKE_SYSTEM_NAME STREQUAL Android)
        # CMP0157 causes swift-collections to fail to compile when targetting
        # Android on Windows due to swift-driver not being present during the
        # toolchain build. Disable it for now.
        cmake_policy(SET CMP0157 OLD)
    else()
        # New Swift build model: improved incremental build performance and LSP support
        cmake_policy(SET CMP0157 NEW)
    endif()
endif()

if (NOT DEFINED CMAKE_C_COMPILER)
    set(CMAKE_C_COMPILER clang)
endif()

project(CoreFoundation
    LANGUAGES C)

if(NOT SWIFT_SYSTEM_NAME)
  if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
    set(SWIFT_SYSTEM_NAME macosx)
  else()
    set(SWIFT_SYSTEM_NAME "$<LOWER_CASE:${CMAKE_SYSTEM_NAME}>")
  endif()
endif()

# Don't enable WMO on Windows due to linker failures
if(NOT CMAKE_HOST_SYSTEM_NAME STREQUAL Windows)
    # Enable whole module optimization for release builds & incremental for debug builds
    if(POLICY CMP0157)
        set(CMAKE_Swift_COMPILATION_MODE "$<IF:$<CONFIG:Release>,wholemodule,incremental>")
    else()
        add_compile_options($<$<AND:$<COMPILE_LANGUAGE:Swift>,$<CONFIG:Release>>:-wmo>)
    endif()
endif()

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)

option(BUILD_SHARED_LIBS "build shared libraries" ON)
option(BUILD_FULLY_STATIC "build fully static" OFF)

# Optionally build tools (on by default) but only when building shared libraries
if(BUILD_SHARED_LIBS)
    option(FOUNDATION_BUILD_TOOLS "build tools" ON)
endif()

set(FOUNDATION_BUILD_NETWORKING_default OFF)
option(FOUNDATION_BUILD_NETWORKING "build FoundationNetworking"
    ${FOUNDATION_BUILD_NETWORKING_default})

set(CMAKE_POSITION_INDEPENDENT_CODE YES)

# Fetchable dependencies
#include(FetchContent)
#set(_SwiftFoundationICU_SourceDIR "/Users/me/Developer/nextspace.FreeBSD/swift-foundation-icu")
#if (_SwiftFoundationICU_SourceDIR)
#    FetchContent_Declare(SwiftFoundationICU
#        SOURCE_DIR ${_SwiftFoundationICU_SourceDIR})
##else()
##    FetchContent_Declare(SwiftFoundationICU
##        GIT_REPOSITORY https://github.com/apple/swift-foundation-icu.git
##        GIT_TAG 0.0.9)
#endif()

#FetchContent_MakeAvailable(SwiftFoundationICU)

include(CheckLinkerFlag)
include(CheckSymbolExists)

check_linker_flag(C "LINKER:--build-id=sha1" LINKER_SUPPORTS_BUILD_ID)

# Detect if the system libc defines symbols for these functions.
# If it is not available, swift-corelibs-foundation has its own implementations
# that will be used. If it is available, it should not redefine them.
# Note: SwiftPM does not have the ability to introspect the contents of the SDK
#       and therefore will always include these functions in the build and will
#       cause build failures on platforms that define these functions.
check_symbol_exists("strlcat" "string.h" HAVE_STRLCAT)
check_symbol_exists("strlcpy" "string.h" HAVE_STRLCPY)
check_symbol_exists("issetugid" "unistd.h" HAVE_ISSETUGID)
add_compile_definitions(
  $<$<AND:$<COMPILE_LANGUAGE:C>,$<BOOL:${HAVE_STRLCAT}>>:HAVE_STRLCAT>
  $<$<AND:$<COMPILE_LANGUAGE:C>,$<BOOL:${HAVE_STRLCPY}>>:HAVE_STRLCPY>
  $<$<AND:$<COMPILE_LANGUAGE:C>,$<BOOL:${HAVE_ISSETUGID}>>:HAVE_ISSETUGID>)

if(CMAKE_SYSTEM_NAME STREQUAL Linux)
  check_symbol_exists(sched_getaffinity "sched.h" HAVE_SCHED_GETAFFINITY)
  add_compile_definitions($<$<COMPILE_LANGUAGE:C>:HAVE_SCHED_GETAFFINITY>)

  # Pass -fno-omit-frame-pointer while compiling for better backtraces
  add_compile_options(
    "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-Xcc -fno-omit-frame-pointer>"
    "$<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>")
endif()

# System dependencies

# We know libdispatch is always unavailable on WASI
if(NOT CMAKE_SYSTEM_NAME STREQUAL "WASI")
    find_package(LibRT)
    find_package(dispatch CONFIG)
    if(NOT dispatch_FOUND)
        if(CMAKE_SYSTEM_NAME STREQUAL "Linux" OR CMAKE_SYSTEM_NAME STREQUAL "Android")
            set(DEFAULT_DISPATCH_INCLUDE_PATH "/usr/NextSpace/include")
        elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
            set(DEFAULT_DISPATCH_INCLUDE_PATH "$ENV{SDKROOT}usr/include")
        endif()
        set(DISPATCH_INCLUDE_PATH "${DEFAULT_DISPATCH_INCLUDE_PATH}" CACHE STRING "A path to where you can find libdispatch headers")
        message("-- dispatch_DIR not found, using dispatch from SDK at ${DISPATCH_INCLUDE_PATH}")
        list(APPEND _Foundation_common_build_flags
            "-I${DISPATCH_INCLUDE_PATH}"
            "-I${DISPATCH_INCLUDE_PATH}/Block")
    endif()
endif()
if(ANDROID)
  # LibXml2 looks for the Threads package, so
  # ensure that it doesn't try to use the `-pthread`
  # flag on Android.
  set(CMAKE_HAVE_LIBC_PTHREAD YES)
endif()
find_package(LibXml2 REQUIRED)
if(FOUNDATION_BUILD_NETWORKING)
    find_package(CURL REQUIRED)
endif()

# Common build flags (_CFURLSessionInterface, _CFXMLInterface, CoreFoundation)
list(APPEND _Foundation_common_build_flags
    "-DHAVE_STRUCT_TIMESPEC"
    "-DCF_BUILDING_CF"
    "-Wno-shorten-64-to-32"
    "-Wno-deprecated-declarations"
    "-Wno-unreachable-code"
    "-Wno-conditional-uninitialized"
    "-Wno-unused-variable"
    "-Wno-unused-function"
    "-Wno-microsoft-enum-forward-reference"
    "-Wno-int-conversion"
    "-Wno-switch"
    "-fblocks")

if(NOT "${CMAKE_C_SIMULATE_ID}" STREQUAL "MSVC")
#    list(APPEND _Foundation_common_build_flags
#        "-fconstant-cfstrings"
#        "-fdollars-in-identifiers"
#        "-fno-common"
#        "-fcf-runtime-abi=swift")

    if(NOT CMAKE_SYSTEM_NAME STREQUAL OpenBSD)
        list(APPEND _Foundation_common_build_flags
            "-fexceptions")
    endif()
else()
    list(APPEND _Foundation_common_build_flags
        "/EHsc"
        "/clang:-fcf-runtime-abi=swift")
endif()

set(CMAKE_INSTALL_REMOVE_ENVIRONMENT_RPATH ON)
set(CMAKE_INSTALL_RPATH "$ORIGIN")
if(CMAKE_SYSTEM_NAME MATCHES "OpenBSD|DragonFlyBSD")
    add_link_options("LINKER:-z,origin")
endif()

if(CMAKE_BUILD_TYPE STREQUAL Debug)
    list(APPEND _Foundation_common_build_flags
        "-DDEBUG")
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Linux" OR CMAKE_SYSTEM_NAME STREQUAL "Android")
    list(APPEND _Foundation_common_build_flags
        "-D_GNU_SOURCE")
endif()

include(GNUInstallDirs)
include(FoundationSwiftSupport)

add_subdirectory(CoreFoundation)
add_subdirectory(cmake/modules)
