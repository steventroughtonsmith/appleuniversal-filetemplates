#!/bin/sh
DESTINATION=~/Library/Developer/Xcode/Templates/File\ Templates
mkdir -p "$DESTINATION"
cp -R Source "$DESTINATION"
echo "Installed to $DESTINATION"