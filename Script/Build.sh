#!/bin/bash
target=$1

dateTime="`date +_%Y%m%d-%H%M%S`"

buildPath=$target"Build"$dateTime

lastBuildPath=$target"Build*"

buildIphoneFrameworkPath="build/Release-iphoneos/"$target".framework"

buildSimulatorFrameworkPath="build/Release-iphonesimulator/"$target".framework"

outFrameworkPath=$buildPath"/"$target".framework"

buildReleaseFrameworkPath="build/Release-iphoneos/"$target".framework"

currentFile=$0

ftpShellPath="BuildScript/ftp.sh"

# Remove last build path 

rm -rf $lastBuildPath

# Create output directory.
mkdir $buildPath

# clean
xcodebuild  clean -target $target

# Build Framework for iOS Simulator.
xcodebuild  build BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" GCC_GENERATE_DEBUGGING_SYMBOLS=NO DEPLOYMENT_POSTPROCESSING=YES STRIP_INSTALLED_PRODUCT=YES STRIP_STYLE=non-global -target $target -configuration Release -sdk iphonesimulator

# Build Framework for iOS Device.
xcodebuild  build BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" GCC_GENERATE_DEBUGGING_SYMBOLS=NO DEPLOYMENT_POSTPROCESSING=YES STRIP_INSTALLED_PRODUCT=YES STRIP_STYLE=non-global -target $target -configuration Release -sdk iphoneos

# Copy the public headers into the framework.
cp -r $buildIphoneFrameworkPath $outFrameworkPath

# Combine iOS Device and Simulator
lipo -create $buildSimulatorFrameworkPath"/"$target $buildIphoneFrameworkPath"/"$target -output $outFrameworkPath"/"$target

# Remove script

#rm -rf $outFrameworkPath"/"$(basename $BASH_SOURCE)

#zip framework

#version
plistFile="${target}/Info.plist"
PlistBuddy="/usr/libexec/PlistBuddy"
version=$($PlistBuddy -c "Print :CFBundleShortVersionString" $plistFile)

zipFrameworkPath=$buildPath"/"$target"-iOS-"$version".zip"

zip -r $zipFrameworkPath $outFrameworkPath

# Remove build directories

rm -rf build

# open frameworkpath

open $buildPath

##ftp
#osascript -e 'tell app "Terminal"
#do script "sh '${SRCROOT}/${ftpShellPath}' '${SRCROOT}/${zipFrameworkPath}'"
#end tell'

