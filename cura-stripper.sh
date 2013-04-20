#!/bin/bash

VERSION=$1

tar -xzf Cura-$VERSION-linux.tar.gz || exit 1
cd Cura-$VERSION-linux

# Remove pypy
# It is not nonfree but it is not needed and removing it reduces the filesize
rm -rf pypy

cd Cura

# Remove CC BY-NC content
# It cannot be shipped with/in Fedora, as it has use restrictions 
rm -f resources/meshes/*
rm -f resources/example/UltimakerRobot_support.stl

# Drop the note about the removal
echo -e '\n\nPlease note, that files under the terms of CC BY-NC has been removed form this Fedora package for legal reasons.' >> resources/example/Attribution.txt

# Use free UltimakerHandle.stl instead of UltimakerRobot_support.stl
FILES=`grep -r "UltimakerRobot_support.stl" . | cut -f1 -d: | sort | uniq | grep -v Attribution.txt | tr '\n' ' '`
sed -i 's/UltimakerRobot_support.stl/UltimakerHandle.stl/g' $FILES

# Remove the firmware
# It is binary, so it is prohibited in Fedora
rm -rf resources/firmware

cd ../..
rm -f Cura-$VERSION-linux-fedora.tar.gz
tar -czf Cura-$VERSION-linux-fedora.tar.gz Cura-$VERSION-linux
