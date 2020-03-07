#!/bin/sh -l

# Install R
echo "\e[1mInstalling R and dependencies"
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y r-base
apt-get install -y r-base r-base-dev r-cran-xml r-cran-rjava libcurl4-openssl-dev
apt-get install -y libssl-dev libxml2-dev openjdk-7-* libgdal-dev libproj-dev libgsl-dev
apt-get install -y xml2 default-jre default-jdk mesa-common-dev libglu1-mesa-dev freeglut3-dev 
apt-get install -y mesa-common-dev libx11-dev r-cran-rgl r-cran-rglpk r-cran-rsymphony r-cran-plyr 
apt-get install -y  r-cran-reshape  r-cran-reshape2 r-cran-rmysql

# Check for build only
if [ "$1" = "build" ]; then
    echo "\e[33m\e[1mRunning only build task"
    R CMD build ./
fi

# Build and check
if [ "$1" = "all" ]; then
    echo "\e[33m\e[1mRunning all tasks"
    echo "\e[33m\e[1mStart package build"
    R CMD build ./
    echo "\e[33m\e[1mPackage build ended"
    # Check if description file exi
    if [ -f DESCRIPTION ]; then
        echo "\e[33m\e[1mDESCRIPTION exist"
        apt-get -y install texlive-latex-base

        echo "\e[33m\e[1mGet package name and version from description file"
        package=$(grep -Po 'Package:(.*)' DESCRIPTION)
        version=$(grep -Po 'Version:(.*)' DESCRIPTION)
        package=${package##Package: }
        version=${version##Version: }

        echo "\e[33m\e[1mStart package check and test for ${package}_${version}"
        if [-f "${package}_${version}" ]; then
            R CMD check ./"${package}_${version}" --as-cran
        else 
           echo "\e[31m\e[1mPackage did not build properly, no package to test"
           exit 1 
    else 
        echo "\e[31m\e[1mDESCRIPTION file does not exist"
        exit 1
    fi
fi
