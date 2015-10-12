# Copyright (C) 2015 Florian Franzen
project(cbsdk CXX)
cmake_minimum_required(VERSION 2.8.12)

set(CBSDK_VERSION_MAJOR 6)
set(CBSDK_VERSION_MINOR 4)
set(CBSDK_VERSION_PATCH 0)
set(CBSDK_VERSION
${CBSDK_VERSION_MAJOR}.${CBSDK_VERSION_MINOR}.${CBSDK_VERSION_PATCH})

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
# Include header files #
########################
include_directories(
    src/cbhwlib
    src/Central
    src/CentralCommon
)

if(WIN32)
    # Include windows specific headers
    include_directories(src/compat)
endif(WIN32)

#################
# Build library #
#################
set(SRC_FILES
    src/cbsdk.cpp
    src/cbhwlib/cbhwlib.cpp
    src/cbhwlib/cbHwlibHi.cpp
    src/cbhwlib/CCFUtils.cpp
    src/cbhwlib/CCFUtilsBinary.cpp
    src/cbhwlib/CCFUtilsConcurrent.cpp
    src/cbhwlib/CCFUtilsXml.cpp
    src/cbhwlib/CCFUtilsXmlItems.cpp
    src/cbhwlib/InstNetwork.cpp
    src/cbhwlib/XmlFile.cpp
    src/Central/Instrument.cpp
    src/Central/UDPsocket.cpp
)

add_library(cbsdk SHARED ${SRC_FILES})

################
# Link library #
################
if(WITH_QT4)
    target_link_libraries(cbsdk Qt4::QtCore Qt4::QtXml)
else()
    target_link_libraries(cbsdk Qt5::Concurrent Qt5::Xml)
endif()

if(WIN32)
    # Windows sockets require theses libraries
    target_link_libraries(cbsdk ws2_32 winmm)
endif(WIN32)

###################
# Install library #
###################
# Group headers in same subfolder
set(INCLUDE_FILE_DESTINATION "include/cbsdk")

install(TARGETS cbsdk EXPORT targets
        DESTINATION lib
        INCLUDES DESTINATION ${INCLUDE_FILE_DESTINATION})

set(HEADER_FILES
    src/cbsdk.h
    src/cbhwlib/cbhwlib.h
)

install(FILES ${HEADER_FILES} DESTINATION ${INCLUDE_FILE_DESTINATION})

##############################
# Create CMake package files #
##############################
set(CMAKE_PACKAGE_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/cmake")

# Create targets file
export(TARGETS targets
       FILE "${CMAKE_PACKAGE_BUILD_DIR}/${PROJECT_NAME}Targets.cmake"
)

# Create config file
configure_file(cmake/PackageConfig.cmake
    "${CMAKE_PACKAGE_BUILD_DIR}/${PROJECT_NAME}Config.cmake"
    @ONLY)

# Create version file
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    "${CMAKE_PACKAGE_BUILD_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    VERSION ${CBSDK_VERSION}
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
install(EXPORT targets
        DESTINATION ${CMAKE_PACKAGE_FILE_DESTINATION}
        FILE "${PROJECT_NAME}Targets.cmake")
