#!/bin/sh

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    brew update
    brew install $QT_VERSION
    if [ "$QT_VERSION" = "qt5" ]; then
        brew link --force qt5
        ln -s /usr/local/opt/qt5/mkspecs /usr/local/mkspecs
        ln -s /usr/local/opt/qt5/plugins /usr/local/plugins
    fi
fi
