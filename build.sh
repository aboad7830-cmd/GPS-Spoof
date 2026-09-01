#!/bin/bash

# GPS Spoof Installation Script
echo "Installing GPS Spoof Tweak..."

# Check if Theos is installed
if [ ! -d "$THEOS" ]; then
    echo "Error: THEOS environment not set"
    exit 1
fi

# Build the tweak
echo "Building GPS Spoof..."
make clean
make package FINALPACKAGE=1

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "Package location: ./packages/"
else
    echo "❌ Build failed!"
    exit 1
fi

exit 0
