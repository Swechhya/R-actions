#!/bin/sh -l

# Install R
echo "Installing R and dependencies"
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y r-base
apt-get install -y r-base r-base-dev r-cran-xml r-cran-rjava libcurl4-openssl-dev
apt-get install -y libssl-dev libxml2-dev openjdk-7-* libgdal-dev libproj-dev libgsl-dev
apt-get install -y xml2 default-jre default-jdk mesa-common-dev libglu1-mesa-dev freeglut3-dev 
apt-get install -y mesa-common-dev libx11-dev r-cran-rgl r-cran-rglpk r-cran-rsymphony r-cran-plyr 
apt-get install -y  r-cran-reshape  r-cran-reshape2 r-cran-rmysql

# Check for build only
if [ "$1" = "build" ]; then
    echo "Running only build task"
    R CMD build ./
fi

# Build and check
if [ "$1" = "all" ]; then
    echo "Running all tasks"
    R CMD build ./
    # Check if description file exi
    if [ -f DESCRIPTION ]; then
        echo "DESCRIPTION exist"
        apt-get -y install texlive-latex-base

        while read -r line; do
            [[ $line =~ ^(Package:)]] && package_name="${line#*${BASH_REMATCH[1]}}"$'\n'"$package_name"
            [[ $line =~ ^(Version:)]] && version="${line#*${BASH_REMATCH[1]}}"
        done < DESCRIPTION
        R CMD check ./"${package_name}_${version}" --as-cran
    else 
        echo "DESCRIPTION does not exist"
    fi
fi
