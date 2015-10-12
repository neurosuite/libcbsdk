#!/bin/sh

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    if [ "$QT_VERSION" = "qt5" ]; then
        sudo add-apt-repository -y ppa:beineri/opt-qt55
    fi
    sudo add-apt-repository -y ppa:smspillaz/cmake-2.8.12
    sudo apt-get update
    sudo apt-get install -y cmake cmake-data

    if [ "$QT_VERSION" = "qt4" ]; then
        sudo apt-get install -y libqt4-xml
    fi
    if [ "$QT_VERSION" = "qt5" ]; then
        sudo apt-get install -y qt55base
        source /opt/qt55/bin/qt55-env.sh
    fi
fi

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    brew update
    brew install $QT_VERSION
    if [ "$QT_VERSION" = "qt5" ]; then
        brew link --force qt5
        ln -s /usr/local/opt/qt5/mkspecs /usr/local/mkspecs
        ln -s /usr/local/opt/qt5/plugins /usr/local/plugins
    fi
fi
