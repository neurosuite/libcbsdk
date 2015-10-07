# Copyright (C) 2015 Florian Franzen

########################
# Include header files #
########################
include_directories(
    cbhwlib
    Central
    CentralCommon
)

if(WIN32)
    # Include windows specific headers
    include_directories(compat)
endif(WIN32)

#################
# Build library #
#################
set(SRC_FILES
    cbsdk.cpp
    cbhwlib/cbhwlib.cpp
    cbhwlib/cbHwlibHi.cpp
    Central/Instrument.cpp
    Central/UDPsocket.cpp
    cbhwlib/InstNetwork.cpp
    cbhwlib/CCFUtils.cpp
    cbhwlib/CCFUtilsBinary.cpp
    cbhwlib/CCFUtilsConcurrent.cpp
    cbhwlib/CCFUtilsXml.cpp
    cbhwlib/CCFUtilsXmlItems.cpp
    cbhwlib/XmlFile.cpp
)

add_library(cbsdk SHARED ${SRC_FILES})
#set_property(TARGET cbsdk PROPERTY VERSION ${CBSDK_VERSION})

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
        LIBRARY DESTINATION lib
        INCLUDES DESTINATION ${INCLUDE_FILE_DESTINATION})

set(HEADER_FILES
    cbsdk.h
    cbhwlib/cbhwlib.h
)

install(FILES ${HEADER_FILES} DESTINATION ${INCLUDE_FILE_DESTINATION})

##############################
# Create CMake package files #
##############################
set(CMAKE_PACKAGE_FILE_DESTINATION "lib/cmake/${PROJECT_NAME}")

# Install config file directly
install(EXPORT targets
        DESTINATION ${CMAKE_PACKAGE_FILE_DESTINATION}
        FILE "${PROJECT_NAME}Config.cmake")

# Create version file...
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  VERSION ${CBSDK_VERSION}
  COMPATIBILITY SameMajorVersion
)
#... and install it
install(
  FILES "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  DESTINATION ${CMAKE_PACKAGE_FILE_DESTINATION}
  COMPONENT Development
)
