#!/bin/sh

#  run.sh
#  BaltoSDK
#
#  Created by h.terashima on 2016/01/18.
#  Copyright © 2016年 goodpatch. All rights reserved.

###############
# For archive #
###############

APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

# This script loops through the frameworks embedded in the application and
# removes unused architectures.
find "$APP_PATH" -name 'BaltoSDK.framework' -type d | while read -r FRAMEWORK
do
    FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
    FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
    echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

    EXTRACTED_ARCHS=()

    for ARCH in $ARCHS
    do
        echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
        lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
        EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
    done

    echo "Merging extracted architectures: ${ARCHS}"
    lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
    rm "${EXTRACTED_ARCHS[@]}"

    echo "Replacing original executable with thinned version"
    rm "$FRAMEWORK_EXECUTABLE_PATH"
    mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"
done


####################
# For Balto upload #
####################

UUID=`uuidgen`
KEY="Balto"
PLIST="${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
PLIST_BUDDY="/usr/libexec/PlistBuddy"

currentVersion=$($PLIST_BUDDY -c "Print ${KEY}" "${PLIST}")
if [ $? = 1 ]; then
    $PLIST_BUDDY -c "Add :${KEY} string '${UUID}'" "${PLIST}"
else
    $PLIST_BUDDY -c "Set :${KEY} '${UUID}'" "${PLIST}"
fi

QUERIES_KEY="LSApplicationQueriesSchemes"
QUERIES=$($PLIST_BUDDY -c "Print ${QUERIES_KEY}" "${PLIST}")
if [ $? = 1 ]; then
    $PLIST_BUDDY -c "Add :${QUERIES_KEY} array" "${PLIST}"
    $PLIST_BUDDY -c "Add :${QUERIES_KEY}:0 string 'dev-balto'" "${PLIST}"
    $PLIST_BUDDY -c "Add :${QUERIES_KEY}:0 string 'balto'" "${PLIST}"
else
    if [[ ${QUERIES} =~ balto ]]; then
        echo "Already exist balto"
    else
        $PLIST_BUDDY -c "Add :${QUERIES_KEY}:0 string 'dev-balto'" "${PLIST}"
        $PLIST_BUDDY -c "Add :${QUERIES_KEY}:0 string 'balto'" "${PLIST}"
    fi
fi

UrlTypesKey="CFBundleURLTypes"
UrlSchemesKey="CFBundleURLSchemes"

exist=1
type=0
urlTypeCheck=$($PLIST_BUDDY -c "Print ${UrlTypesKey}" "${PLIST}")
if [ $? = 1 ]; then
    exist=0
    type=0
else
    urlTypeCheck=$($PLIST_BUDDY -c "Print ${UrlTypesKey}:0:${UrlSchemesKey}" "${PLIST}")
    if [ $? = 1 ]; then
        exist=0
        type=1
    fi
fi

if [ $exist = 0 ]; then
    if [ $type = 0 ]; then
        $PLIST_BUDDY -c "Add :${UrlTypesKey} array" "${PLIST}"
    fi
    len=12
    char='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'
    char_len=${#char}
    i=0
    while [ $i -lt $len ]
    do
        start=$(( ($RANDOM % $char_len) ))
        str=${str}${char:${start}:1}
        i=$(( i+1 ))
    done

    $PLIST_BUDDY -c "Add :${UrlTypesKey}:0:${UrlSchemesKey} array" "${PLIST}"
    $PLIST_BUDDY -c "Add :${UrlTypesKey}:0:${UrlSchemesKey}:0 string ${str}" "${PLIST}"
fi
