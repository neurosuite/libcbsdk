/* =STS=> StdAfx.h[1724].aa02   open     SMID:2 */
/////////////////////////////////////////////////////////////////////////////
//
// (c) Copyright 2003 - 2006 Cyberkinetics, Inc.
// (c) Copyright 2007 - 2012 Blackrock Microsystems
//
// $Workfile: $
// $Archive: $
// $Revision: $
// $Date: $
// $Author: $
//
// $NoKeywords: $
//
//////////////////////////////////////////////////////////////////////
// StdAfx.h :
//  Include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//
//  It also serves the purpose of x-platform compatibility
//

#ifndef _CBSDK_CBHWLIB_STFAFX_H_
#define _CBSDK_CBHWLIB_STFAFX_H_

#ifdef __APPLE__

    #define ERR_UDP_MESSAGE \
            "Unable to assign UDP interface memory\n" \
            " Consider nvram boot-args=\"ncl=65536\"\n" \
            "          sysctl -w kern.ipc.maxsockbuf=8388608 and\n" \
            " Requirement of the first command depends on system memory\n" \
            " That may need to change boot parameters on OSX (and needs to reboot before the sysctl command) \n" \
            " It is possible to use 'receive-buffer-size' parameter when opening the library to override this\n" \
            " Any value below 4194304 may degrade the performance and must be avoided\n" \
            " Use 8388608 or more for maximum efficiency"

#else

    #define ERR_UDP_MESSAGE \
            "Unable to assign UDP interface memory\n" \
            " Consider sysctl -w net.core.rmem_max=8388608\n" \
            " It is possible to use 'receive-buffer-size' parameter when opening the library to override this\n" \
            " Any value below 4194304 may degrade the performance and must be avoided\n" \
            " Use 8388608 or more for maximum efficiency"

#endif

#if _MSC_VER > 1000
    #pragma once
#endif // _MSC_VER > 1000

#include <string.h>
#include <stdio.h>

#ifdef WIN32
    #include <winsock2.h>
    #include <windows.h>

    #define _CRT_SECURE_NO_DEPRECATE
    #define _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES 1
    #define _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES_COUNT 1
#else
    #include <stdlib.h>
    #define _strcmpi strcasecmp
    #define _strnicmp strncasecmp
    #define _snprintf snprintf
#endif

#endif // !defined(_CBSDK_CBHWLIB_STFAFX_H_)
