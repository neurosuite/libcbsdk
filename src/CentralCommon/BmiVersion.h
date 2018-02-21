/* =STS=> BmiVersion.h[4256].aa04   submit   SMID:5 */
//////////////////////////////////////////////////////////////////////////////
//
// (c) Copyright 2010 - 2014 Blackrock Microsystems
//
// $Workfile: BmiVersion.h $
// $Archive: /CentralCommon/BmiVersion.h $
// $Revision: 1 $
// $Date: 7/19/10 9:52a $
// $Author: Ehsan $
//
// $NoKeywords: $
//
//////////////////////////////////////////////////////////////////////////////
//
// PURPOSE:
//
// Blackrock Microsystems product version information
//

#ifndef BMIVERSION_H_INCLUDED
#define BMIVERSION_H_INCLUDED

#define STR(s) #s
#define STRINGIFY(s) STR(s)

#define BMI_VERSION_MAJOR       7
#define BMI_VERSION_MINOR       0
#define BMI_VERSION_REVISION    2
#define BMI_VERSION_BUILD       0

#define BMI_VERSION           BMI_VERSION_MAJOR,BMI_VERSION_MINOR,BMI_VERSION_RELEASE,BMI_VERSION_BETA

#if BMI_VERSION_BUILD == 0
#define BMI_VERSION_STR       STRINGIFY(BMI_VERSION_MAJOR) "." STRINGIFY(BMI_VERSION_MINOR) \
    "." STRINGIFY(BMI_VERSION_REVISION)
#else
#define BMI_VERSION_STR       STRINGIFY(BMI_VERSION_MAJOR) "." STRINGIFY(BMI_VERSION_MINOR) \
    "." STRINGIFY(BMI_VERSION_REVISION) " Build " STRINGIFY(BMI_VERSION_BUILD)
#endif

#endif // include guard
