#!/usr/bin/env bash

# $ vnc-build -a [18|19]

DAEMON_BUILD_PATH=libs/armeabi-v7a
LIB_BUILD_PATH=nativeMethods/libs/armeabi-v7a
PUSH_PATH=/sdcard/vnc/files
DEPLOY_PATH=/data/local/tmp
CWD=$(pwd)

android=18
usage="usage: $0 [-a N] -w -s"

clean() {
    if [ -n "$do_build_wrapper" ]; then
        rm ${LIB_BUILD_PATH}/libdvnc_flinger_sdk${android}.so
    fi
    rm ${DAEMON_BUILD_PATH}/*
}

build_wrapper() {
    cd ../src
    . build/envsetup.sh
    cd external/nativeMethods
    mm .
    cd ${CWD}
}

deploy_vnc() {
    SERIAL=$1

    adb -s ${SERIAL} shell "su -c 'rm -d ${DEPLOY_PATH}/* 2>/dev/null'"
    adb -s ${SERIAL} shell "su -c 'rm -d ${PUSH_PATH}/* 2>/dev/null'"

    adb -s ${SERIAL} push ${LIB_BUILD_PATH}/libdvnc_flinger_sdk${android}.so ${PUSH_PATH}/libdvnc_flinger_sdk.so
    adb -s ${SERIAL} push ${DAEMON_BUILD_PATH}/androidvncserver ${PUSH_PATH}/androidvncserver

    if [ -e passwd ]; then
        adb -s ${SERIAL} push passwd ${PUSH_PATH}/passwd
    fi

    adb -s ${SERIAL} shell "su -c 'cp ${PUSH_PATH}/* ${DEPLOY_PATH}/.'"

    adb -s ${SERIAL} shell "su -c 'chmod 777 ${DEPLOY_PATH}/androidvncserver'"
    adb -s ${SERIAL} shell "su -c 'chmod 644 ${DEPLOY_PATH}/libdvnc_flinger_sdk.so'"
    adb -s ${SERIAL} shell "su -c 'chmod 644 ${DEPLOY_PATH}/passwd 2>/dev/null'"
}


while getopts ":a:ws" opt; do
    case $opt in
        a  ) android=$OPTARG ;;
        w  ) do_build_wrapper='yep' ;;
        s  ) skip_deploy='yep' ;;
        \? ) echo $usage
           exit 1 ;;
    esac
done

clean
ndk-build

if [ -n "$do_build_wrapper" ]; then
    build_wrapper
fi

if [ -z "$skip_deploy" ]; then
    serial_numbers=($(adb devices | awk '/device$/{print $1}'))

    for i in "${serial_numbers[@]}"; do
        deploy_vnc $i
    done
fi
