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


# Check if description file exits
DESCRIPTION = './DESCRIPTION'
if [ -f "$DESCRIPTION" ]; then
    echo "$DESCRIPTION exist"
    
else 
    echo "$DESCRIPTION does not exist"
fi
# Check for correct build command
if [ "$1" = "build" ]; then
    echo "Running only build task"
    R CMD build ./

fi

if [ "$1" = "test" ]; then
    echo "Running only test task"
    apt-get -y install texlive-latex-base
    R CMD check ./ --as-cran
    
fi

if [ "$1" = "all" ]; then
    echo "Running all tasks"
    R CMD build ./
    apt-get -y install texlive-latex-base
    R CMD check ./ --as-cran
fi
