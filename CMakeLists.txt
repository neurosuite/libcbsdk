# Copyright (C) 2015 Florian Franzen
project(cbsdk)
cmake_minimum_required(VERSION 2.8.12)

set(CBSDK_VERSION_MAJOR 1)
set(CBSDK_VERSION_MINOR 0)
set(CBSDK_VERSION_PATCH 0)
set(CBSDK_VERSION
${CBSDK_VERSION_MAJOR}.${CBSDK_VERSION_MINOR}.${CBSDK_VERSION_PATCH})

# Options
option(WITH_QT4
       "Enable to build against Qt4 (default: Qt5)"
       OFF)

# Enable exports for library build
add_definitions(-DCBSDK_EXPORTS)

# Disable DataVector.h specific code
add_definitions(-DQT_APP)

if(WIN32)
    # To build on windows the following definitions are needed
    add_definitions(-DWIN32 -D_WINDOWS -DWINVER=0x0501 -DNO_AFX)
endif(WIN32)

if(APPLE)
    # Enable RPATH on OS X (default in CMake >= 3.0)
    set(CMAKE_MACOSX_RPATH ON)
endif(APPLE)

# Configure CMAKE
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

# Find the right Qt
set(CMAKE_AUTOMOC ON)
if(WITH_QT4)
    find_package(Qt4 REQUIRED QtXml)
else()
    find_package(Qt5Concurrent REQUIRED)
    find_package(Qt5Xml REQUIRED)
endif()

# Include main source code directory
add_subdirectory(src)
