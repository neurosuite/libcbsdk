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
    cbhwlib/CCFUtils.cpp
    cbhwlib/CCFUtilsBinary.cpp
    cbhwlib/CCFUtilsConcurrent.cpp
    cbhwlib/CCFUtilsXml.cpp
    cbhwlib/CCFUtilsXmlItems.cpp
    cbhwlib/InstNetwork.cpp
    cbhwlib/XmlFile.cpp
    Central/Instrument.cpp
    Central/UDPsocket.cpp
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
set(INCLUDE_FILE_DESTINATION "include/${PROJECT_NAME}")

install(TARGETS cbsdk
        EXPORT LibraryTargets
        DESTINATION lib
        INCLUDES DESTINATION ${INCLUDE_FILE_DESTINATION})

set(HEADER_FILES
    cbsdk.h
    cbhwlib/cbhwlib.h
)

install(FILES ${HEADER_FILES} DESTINATION ${INCLUDE_FILE_DESTINATION})
