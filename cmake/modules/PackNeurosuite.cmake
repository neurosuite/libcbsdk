# - Functions to help package Neurosuite apps.
#
# The following functions are provided by this module:
#   neurosuite_cpack_init
#   neurosuite_cpack_nsis
#   neurosuite_cpack_dmg
#   neurosuite_cpack_deb
#   neurosuite_cpack_rpm
#   neurosuite_cpack_ubuntu
#   neurosuite_cpack_suse
#   neurosuite_cpack_fedora
#   neurosuite_cpack_scientific
#
# Requires CMake 2.6 or greater because it uses function and
# PARENT_SCOPE.
#
# NEUROSUITE_CPACK_INIT(<name> <version> <maintainer> <summary> <descrip_file>)
#   Initializes CPack variables with some sensible defaults, should to be run
#   before all other neurosuite_cpack_* commands.
#
#   <name>: name of the package to be created, e.g. "libawesome"
#
#   <version>: full version string of package, e.g. "1.2.3"
#
#   <maintainer>: name and email address of maintainer,
#                 e.g. "First Last <First.Last@domain.com>"
#
#   <summary>: summary of description, e.g. "LibAwesome is an awesome library."
#
#   <descrip_file>: file path to full description file, e.g /path/to/file.txt,
#                   set to FALSE to not set a description file
#
# NEUROSUITE_CPACK_NSIS(<target> <target_name> <license_file>)
#   Setup NSIS CPack generator if on Windows.
#
#   <target>: name of the executable target name, e.g. neuroscope
#
#   <target_name>: capitalized/styled name of package, e.g. NeuroScope
#
#   <license_file>: file path to license file, e.g. /path/to/LICENSE.txt
#
# NEUROSUITE_CPACK_DMG()
#   Setup DMG CPack generator if on OS X.
#
# NEUROSUITE_CPACK_DEB(<dist_name> <depend> <script_dir> <pkg_name_templ>)
# NEUROSUITE_CPACK_RPM(<dist_name> <depend> <script_dir> <pkg_name_templ>)
#   Setup DEB or RPM generator if on UNIX (and not OS X) and the distribution
#   matches the supplied name.
#
#   <dist_name>: name or regex of distribution, e.g. "Ubuntu"
#
#   <depend>: comma separated list of dependencies, e.g. "qt, boost, cuda"
#
#   <script_dir>: directory that contains postinst and postrm script,
#                 e.g. /path/to/folder
#
#   <pkg_name_templ>: template string used to create package name,
#                     e.g. "\${NAME}_\${VERSION}_\${RELEASE}_\${ARCHITECTURE}"
#
# NEUROSUITE_CPACK_UBUNTU(<depend> <script_dir>)
# NEUROSUITE_CPACK_SUSE(<depend> <script_dir>)
# NEUROSUITE_CPACK_FEDORA(<depend> <script_dir>)
# NEUROSUITE_CPACK_SCIENTIFIC(<depend> <script_dir>)
#   Wrapper functions around NEUROSUITE_CPACK_RPM and NEUROSUITE_CPACK_DEB, that #   set sensible values for <dist_name> and <pkg_name_templ> for ubuntu, suse,
#   fedora or scientific linux. See above for more information on the
#   parameters.

##############
# CPack init #
##############
function(neurosuite_cpack_init _NAME _VERSION _MAINTAINER _SUMMARY _DESCR_FILE)
    # Set some good system defaults
    set(CPACK_GENERATOR "ZIP" PARENT_SCOPE)
    set(CPACK_SYSTEM_NAME
        "${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}"
        PARENT_SCOPE)

    # Set name, version and vendors
    set(CPACK_PACKAGE_NAME ${_NAME} PARENT_SCOPE)
    set(CPACK_PACKAGE_VERSION ${_VERSION} PARENT_SCOPE)
    set(CPACK_PACKAGE_VENDOR "Neurosuite" PARENT_SCOPE)

    # Use supplied info to all other variables
    set(CPACK_PACKAGE_CONTACT ${_MAINTAINER} PARENT_SCOPE)
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${_SUMMARY} PARENT_SCOPE)
    if(_DESCR_FILE)
        set(CPACK_PACKAGE_DESCRIPTION_FILE ${_DESCR_FILE} PARENT_SCOPE)
    endif()
endfunction()

############################
# Windows specific helpers #
############################

function(neurosuite_cpack_nsis _TARGET _STYLED_NAME _LICENSE_FILE)
    if(WIN32)
        set(CPACK_GENERATOR "NSIS" PARENT_SCOPE)

        # Set name in installer and Add/Remove Program
        set(CPACK_NSIS_PACKAGE_NAME "${_STYLED_NAME}" PARENT_SCOPE)
        set(CPACK_NSIS_DISPLAY_NAME "${_STYLED_NAME}" PARENT_SCOPE)

        # Set install and registry path
        set(CPACK_PACKAGE_INSTALL_DIRECTORY "${_STYLED_NAME}" PARENT_SCOPE)

        set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY ${_TARGET} PARENT_SCOPE)

        # Add link to executable to Start menu
        set(CPACK_PACKAGE_EXECUTABLES
            "${_TARGET}" "${_STYLED_NAME}"
            PARENT_SCOPE)

        # Add license file and default contact info
        if(_LICENSE_FILE)
            set(CPACK_RESOURCE_FILE_LICENSE "${_LICENSE_FILE}" PARENT_SCOPE)
        endif()
        set(CPACK_NSIS_CONTACT ${CPACK_PACKAGE_CONTACT} PARENT_SCOPE)

        # Ask if previous version should be uninstalled
        set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON PARENT_SCOPE)

        # Add website links to Start menu and installer
        set(CPACK_NSIS_MENU_LINKS
            "http:////neurosuite.github.io" "Homepage of ${_STYLED_NAME}" PARENT_SCOPE)
        set(CPACK_NSIS_URL_INFO_ABOUT
            "https:////neurosuite.github.io"
            PARENT_SCOPE)
        set(CPACK_NSIS_HELP_LINK
            "https:////neurosuite.github.io//information.html"
            PARENT_SCOPE)

        # Fix package name and install root depending on architecture
        if(CMAKE_SYSTEM_PROCESSOR STREQUAL "AMD64")
            set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64"  PARENT_SCOPE)
            set(CPACK_SYSTEM_NAME "win64" PARENT_SCOPE)
        else()
            set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES32"  PARENT_SCOPE)
            set(CPACK_SYSTEM_NAME "win32" PARENT_SCOPE)
        endif()
    endif()
endfunction()

#########################
# Apple specific helpers #
#########################
function(neurosuite_cpack_dmg)
    if(APPLE)
        set(CPACK_GENERATOR "DragNDrop" PARENT_SCOPE)
        set(CPACK_DMG_FORMAT "UDBZ" PARENT_SCOPE)
        set(CPACK_SYSTEM_NAME "osx-${CMAKE_SYSTEM_PROCESSOR}" PARENT_SCOPE)
    endif()
endfunction()

#########################
# UNIX specific helpers #
#########################
macro(neurosuite_eval _result _value)
    set(${_result} ${_value} ${ARGN})
endmacro()

function(neurosuite_unix_system_info _DIST_VAR _REL_VAR _ARCH_VAR)
    if(UNIX AND NOT APPLE)
        # Check if lsb_release command is there first...
        find_program(LSB_RELEASE_CMD lsb_release)
        if(LSB_RELEASE_CMD)
            # ... then use it to determine distribution and release
            execute_process(COMMAND ${LSB_RELEASE_CMD} -si
                            OUTPUT_VARIABLE DISTRIBUTION
                            OUTPUT_STRIP_TRAILING_WHITESPACE)
            set(${_DIST_VAR} ${DISTRIBUTION} PARENT_SCOPE)
            execute_process(COMMAND ${LSB_RELEASE_CMD} -sc
                            OUTPUT_VARIABLE RELEASE
                            OUTPUT_STRIP_TRAILING_WHITESPACE)
            set(${_REL_VAR} ${RELEASE} PARENT_SCOPE)
        else()
            message(WARNING "lsb_release command not found, will not be able to  use distribution specific cpack config.")
            set(${_DIST_VAR} "unknown" PARENT_SCOPE)
            set(${_REL_VAR}  "unknown" PARENT_SCOPE)
        endif()

        # Check if dpkg command is there first...
        find_program(DPKG_CMD dpkg)
        if(DPKG_CMD)
            # ... then use it to determine architecture string
            execute_process(COMMAND ${DPKG_CMD} --print-architecture
                OUTPUT_VARIABLE ARCHITECTURE
                OUTPUT_STRIP_TRAILING_WHITESPACE)
            set(${_ARCH_VAR} ${ARCHITECTURE} PARENT_SCOPE)
        else()
            # ... else use uname -p (or whatever they do on Windows or OS X)
            set(${_ARCH_VAR} ${CMAKE_SYSTEM_PROCESSOR} PARENT_SCOPE)
        endif()
    endif()
endfunction()

set(NEUROSUITE_SUGGESTED_PACKAGES
    ndmanager
    ndmanager-plugins
    neuroscope
    klusters
    neurosuite-mime
)

function(neurosuite_cpack_deb _DIST_NAME _DEPENDS _EXTRA_DIR _NAME_TEMPL)
    # Get system information
    neurosuite_unix_system_info(DISTRIBUTION RELEASE ARCHITECTURE)

    if(DISTRIBUTION MATCHES ${_DIST_NAME})
        set(CPACK_GENERATOR "DEB" PARENT_SCOPE)

        # Set defaults
        set(CPACK_DEBIAN_PACKAGE_HOMEPAGE
            "http://neurosuite.github.io"
            PARENT_SCOPE)
        set(CPACK_DEBIAN_PACKAGE_SECTION "Science" PARENT_SCOPE)

        # Set architecture
        set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE ${ARCHITECTURE} PARENT_SCOPE)

        # Set dependencies
        set(CPACK_DEBIAN_PACKAGE_DEPENDS ${_DEPENDS} PARENT_SCOPE)

        # Determine suggested packages
        list(REMOVE_ITEM NEUROSUITE_SUGGESTED_PACKAGES ${CPACK_PACKAGE_NAME})
        string(REPLACE ";" ", "
               CPACK_DEBIAN_PACKAGE_SUGGESTS
               "${NEUROSUITE_SUGGESTED_PACKAGES}")
        set(CPACK_DEBIAN_PACKAGE_SUGGESTS
            "${CPACK_DEBIAN_PACKAGE_SUGGESTS}"
            PARENT_SCOPE)

        # Add install scripts if supplied
        if(_EXTRA_DIR)
            foreach(SCRIPT shlibs postinst prerm postrm)
                if(EXISTS "${_EXTRA_DIR}/${SCRIPT}")
                    list(APPEND CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
                    "${_EXTRA_DIR}/${SCRIPT}")
                endif()
            endforeach()
            set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
                ${CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA}
                PARENT_SCOPE)
        endif()

        # Determine package name
        set(NAME ${CPACK_PACKAGE_NAME})
        set(VERSION ${CPACK_PACKAGE_VERSION})
        neurosuite_eval(CPACK_PACKAGE_FILE_NAME "${_NAME_TEMPL}" PARENT_SCOPE)
    endif()
endfunction()

function(neurosuite_cpack_rpm _DIST_NAME _REQUIRES _SCRIPT_DIR _NAME_TEMPL)
    # Get system information
    neurosuite_unix_system_info(DISTRIBUTION RELEASE ARCHITECTURE)

    if(DISTRIBUTION MATCHES ${_DIST_NAME})
        set(CPACK_GENERATOR "RPM" PARENT_SCOPE)

        # Set defaults
        set(CPACK_RPM_PACKAGE_GROUP "Science" PARENT_SCOPE)
        set(CPACK_RPM_PACKAGE_LICENSE "GPLv2" PARENT_SCOPE)
        set(CPACK_RPM_PACKAGE_URL "http://neurosuite.github.io" PARENT_SCOPE)

        # Set architecture
        set(CPACK_RPM_PACKAGE_ARCHITECTURE ${ARCHITECTURE} PARENT_SCOPE)

        # Set dependencies
        set(CPACK_RPM_PACKAGE_REQUIRES ${_REQUIRES} PARENT_SCOPE)

        # Determine suggested packages
        list(REMOVE_ITEM NEUROSUITE_SUGGESTED_PACKAGES ${CPACK_PACKAGE_NAME})
        string(REPLACE ";" ", "
               CPACK_RPM_PACKAGE_SUGGESTS
               "${NEUROSUITE_SUGGESTED_PACKAGES}")
        set(CPACK_RPM_PACKAGE_SUGGESTS
            "${CPACK_RPM_PACKAGE_SUGGESTS}"
            PARENT_SCOPE)

        # Add script if path supplied
        if(_SCRIPT_DIR)
            if(EXIST "${_SCRIPT_DIR}/postinst")
                set(CPACK_RPM_POST_INSTALL_SCRIPT_FILE
                    "${_SCRIPT_DIR}/postinst"
                    PARENT_SCOPE)
            endif()
            if(EXIST "${_SCRIPT_DIR}/postrm")
                set(CPACK_RPM_POST_UNINSTALL_SCRIPT_FILE
                    "${_SCRIPT_DIR}/postrm"
                    PARENT_SCOPE)
            endif()
        endif()

        # Determine package name
        set(NAME ${CPACK_PACKAGE_NAME})
        set(VERSION ${CPACK_PACKAGE_VERSION})
        neurosuite_eval(CPACK_PACKAGE_FILE_NAME "${_NAME_TEMPL}" PARENT_SCOPE)
    endif()
endfunction()

#################################
# Distribution specific helpers #
#################################
macro(neurosuite_cpack_ubuntu _DEPENDENCIES _EXTRA_DIR)
    neurosuite_cpack_deb("Ubuntu"
                        ${_DEPENDENCIES}
                        ${_EXTRA_DIR}
                        "\${NAME}_\${VERSION}-\${RELEASE}_\${ARCHITECTURE}")
endmacro()

macro(neurosuite_cpack_suse _DEPENDENCIES _SCRIPT_DIR)
    neurosuite_cpack_rpm("openSUSE.*"
                         ${_DEPENDENCIES}
                         ${_SCRIPT_DIR}
                         "\${NAME}-\${VERSION}-\${RELEASE}.\${ARCHITECTURE}")
endmacro()

macro(neurosuite_cpack_fedora _DEPENDENCIES _SCRIPT_DIR)
    neurosuite_cpack_rpm("Fedora"
                         ${_DEPENDENCIES}
                         ${_SCRIPT_DIR}
                         "\${NAME}-\${VERSION}.fc\${RELEASE}.\${ARCHITECTURE}")
endmacro()

macro(neurosuite_cpack_scientific _DEPENDENCIES _SCRIPT_DIR)
    neurosuite_cpack_rpm("Scientific"
                         ${_DEPENDENCIES}
                         ${_SCRIPT_DIR}
                        "\${NAME}-\${VERSION}-\${RELEASE}.\${ARCHITECTURE}")
endmacro()
