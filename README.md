[![Build Status](https://travis-ci.org/neurosuite/libcbsdk.svg)](https://travis-ci.org/neurosuite/libcbsdk)
[![Build status](https://ci.appveyor.com/api/projects/status/lf503790q0pg8pkw/branch/master?svg=true)](https://ci.appveyor.com/project/FloFra/libcbsdk/branch/master)

libcbsdk
========

A C++ library that allows you to interact with Blackrock Microsystems neural signal processing hardware.

This is a fork of [CereLink](https://github.com/dashesy/CereLink) turned it into a standalone C++ library, similar to the CBSDK that comes with Central, without the Matlab dependency, but with Qt5 support and proper CMake package files.

In theory the library should be 100% compatible with any code that previously worked with the *official* CBSDK as long as it only uses the ```cbSdk...``` functions.

For more infos, general trouble shooting information or different licensing options please see the upstream source repository [dashesy/CereLink](https://github.com/dashesy/CereLink).

This code is licensed under GPLv2. (C) by Blackrock Microsystems (LLC) unless noted otherwise.
