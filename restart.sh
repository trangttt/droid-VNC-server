#!/usr/bin/env bash

# Kill the vnc server, recompile and deploy
VNC_PID=$(adb shell ps | awk '/[l]ibandroidvncserver.so/{print $2}')
echo "$VNC_PID"

if [ -n "$VNC_PID" ]
then
    adb shell "su -c 'kill $VNC_PID'"
fi

ndk-build
./updateExecsAndLibs.sh

ant debug install
