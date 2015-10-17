# Copyright (C) 2015 Florian Franzen
project(cbsdk CXX)
cmake_minimum_required(VERSION 2.8.12)

set(PROJECT_VERSION_MAJOR 6)
set(PROJECT_VERSION_MINOR 4)
set(PROJECT_VERSION_PATCH 0)
set(PROJECT_VERSION
    "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}"
)

# Options
option(WITH_QT4
       "Enable to build against Qt4 (default: Qt5)"
       OFF)

###############################
# Configure build environment #
###############################

# Enable exports for library build
add_definitions(-DCBSDK_EXPORTS)

# Disable DataVector.h specific code
add_definitions(-DQT_APP)

if(WIN32)
    # To build on windows the following definitions are needed
    add_definitions(-DWIN32 -D_WINDOWS -DWINVER=0x0501 -DNO_AFX)
    if(MSVC)
        # Some weird versions of MSVC need this
        add_definitions(-DNOMINMAX)
    endif()
endif(WIN32)

if(APPLE)
    # Enable RPATH on OS X (default in CMake >= 3.0)
    set(CMAKE_MACOSX_RPATH ON)
endif(APPLE)

# Configure CMAKE
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

#####################
# Find dependencies #
#####################
# Find correct Qt library
set(CMAKE_AUTOMOC ON)
if(WITH_QT4)
    find_package(Qt4 REQUIRED QtXml)
else()
    find_package(Qt5Concurrent REQUIRED)
    find_package(Qt5Xml REQUIRED)
endif()

########################
# Include subdirectory #
########################
# Build main library
add_subdirectory(src)

##############################
# Create CMake package files #
##############################
set(CMAKE_PACKAGE_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/cmake")

# Create targets file
export(TARGETS cbsdk
       FILE "${CMAKE_PACKAGE_BUILD_DIR}/${PROJECT_NAME}Targets.cmake"
)

# Create config file
configure_file(cmake/PackageConfig.cmake
    "${CMAKE_PACKAGE_BUILD_DIR}/${PROJECT_NAME}Config.cmake"
    @ONLY
)

# Create version file
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    "${CMAKE_PACKAGE_BUILD_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

###############################
# Install CMake package files #
###############################
if(WIN32)
    set(CMAKE_PACKAGE_FILE_DESTINATION "CMake")
else()
    set(CMAKE_PACKAGE_FILE_DESTINATION "lib/cmake/${PROJECT_NAME}")
endif()

# Install config and version
install(FILES "${CMAKE_PACKAGE_BUILD_DIR}/${PROJECT_NAME}Config.cmake"
              "${CMAKE_PACKAGE_BUILD_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
        DESTINATION ${CMAKE_PACKAGE_FILE_DESTINATION}
)

# Install target
install(EXPORT LibraryTargets
        DESTINATION ${CMAKE_PACKAGE_FILE_DESTINATION}
        FILE "${PROJECT_NAME}Targets.cmake"
)

######################
# CPack Configuriton #
######################
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")
include(PackNeurosuite)
# Init CPack variables
neurosuite_cpack_init("lib${PROJECT_NAME}"
                       ${PROJECT_VERSION}
                       "Florian Franzen <FlorianFranzen@gmail.com"
                       "Library to interact with Blackrock Microsystems neural signal processing hardware"
                       OFF)

# Use deb and rpm on linux
if(WITH_QT4)
    neurosuite_cpack_ubuntu(
        "libqt4-xml"
        OFF
    )
else()
    neurosuite_cpack_ubuntu(
        "libqt5concurrent5, libqt5xml5"
        OFF
    )
endif()

include(CPack)
