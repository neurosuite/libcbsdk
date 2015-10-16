# Find packages of dependencies
include(CMakeFindDependencyMacro)

set(@PROJECT_NAME@_WITH_QT4 @WITH_QT4@)
if(@PROJECT_NAME@_WITH_QT4)
    find_dependency(Qt4)
else()
    find_dependency(Qt5Concurrent)
    find_dependency(Qt5Xml)
endif()

# Make sure the headers do not use AFX
add_definitions(-DNO_AFX)

# Include target definition (includes and definition)
include("${CMAKE_CURRENT_LIST_DIR}/@PROJECT_NAME@Targets.cmake")
