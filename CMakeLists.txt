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
endif(WIN32)

if(APPLE)
    # Enable RPATH on OS X (default in CMake >= 3.0)
    set(CMAKE_MACOSX_RPATH ON)
endif(APPLE)

# Configure CMAKE
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

# Detect 64bit build
set(PROJECT_IS_64BIT CMAKE_SIZEOF_VOID_P EQUAL 8)

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

# Create targets file (disabled, does not work in cmake < 3.0.0)
# export(EXPORT LibraryTargets
#        FILE "${CMAKE_PACKAGE_BUILD_DIR}/${PROJECT_NAME}Targets.cmake"
# )

# Create config file
configure_file(cmake/PackageConfig.cmake.in
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
set(CPACK_PACKAGE_NAME "lib${PROJECT_NAME}")
set(CPACK_PACKAGE_CONTACT "Florian Franzen <FlorianFranzen@gmail.com>")

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Library to interact with Blackrock Microsystems neural signal processing hardware")

set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})

if(WIN32)
    set(CPACK_GENERATOR "NSIS")
    if(PROJECT_IS_64BIT)
        set(CPACK_SYSTEM_NAME "win64")
    else()
        set(CPACK_SYSTEM_NAME "win32")
    endif()
elseif(APPLE)
    set(CPACK_GENERATOR "ZIP")
    set(CPACK_SYSTEM_NAME "osx")
else()
    set(CPACK_GENERATOR "DEB")

    if(PROJECT_IS_64BIT)
        set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "amd64")
    else()
        set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "i386")
    endif()
    set(CPACK_SYSTEM_NAME "${CPACK_DEBIAN_PACKAGE_ARCHITECTURE}")

    if(WITH_QT4)
        set(CPACK_DEBIAN_PACKAGE_DEPENDS "libqt4-xml (>= 4.8.0)")
    else()
        set(CPACK_DEBIAN_PACKAGE_DEPENDS "libqt5concurrent5, libqt5xml5")
    endif()

    set(CPACK_DEBIAN_PACKAGE_SECTION "Science")
    set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://neurosuite.github.io/")
endif()

if(WITH_QT4)
    set(CPACK_SYSTEM_NAME "${CPACK_SYSTEM_NAME}-qt4")
else()
    set(CPACK_SYSTEM_NAME "${CPACK_SYSTEM_NAME}-qt5")
endif()

include(CPack)
