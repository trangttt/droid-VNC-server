#!/usr/bin/env bash

# $ vnc-build -a [18|19]

DAEMON_BUILD_PATH=libs/armeabi-v7a
LIB_BUILD_PATH=nativeMethods/libs/armeabi-v7a
PUSH_PATH=/sdcard/vnc/files
DEPLOY_PATH=/data/local
CWD=$(pwd)

android=18
usage="usage: $0 [-a N] -w"

build_wrapper() {
    cd ../src
    . build/envsetup.sh
    cd external/nativeMethods
    mm .
    cd ${CWD}
}

while getopts ":a:w" opt; do
    case $opt in
        a  ) android=$OPTARG ;;
        w  ) build_wrapper ;;
        \? ) echo $usage
           exit 1 ;;
    esac
done

ndk-build
adb push ${LIB_BUILD_PATH}/libdvnc_flinger_sdk${android}.so ${PUSH_PATH}/libdvnc_flinger_sdk.so
adb push ${DAEMON_BUILD_PATH}/androidvncserver ${PUSH_PATH}/androidvncserver

adb shell "su -c 'cp ${PUSH_PATH}/* ${DEPLOY_PATH}/.'"

adb shell "su -c 'chmod 777 ${DEPLOY_PATH}/androidvncserver'"
adb shell "su -c 'chmod 644 ${DEPLOY_PATH}/libdvnc_flinger_sdk.so'"
