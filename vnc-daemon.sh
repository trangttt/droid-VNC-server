#!/usr/bin/env bash

# $ vnc-daemon -s 10 -m [fb|gb|adb] [start|stop|restart]

DAEMON_PATH=/data/local

usage="usage: $0 [-s N] [-m S] [start|stop|restart]"

scale="100"
method="flinger"
action="restart"

kill_server() {
    VNC_PID=$(adb shell ps | awk '/[a]ndroidvncserver/{print $2}')
    if [ -n "$VNC_PID" ]; then
        adb shell "su -c 'kill $VNC_PID'"
    fi
}

start_server() {
    PASS_CMD="'./${DAEMON_PATH}/androidvncserver -s ${scale} -m ${method} -e ${DAEMON_PATH}/passwd'"
    NOPASS_CMD="'./${DAEMON_PATH}/androidvncserver -s ${scale} -m ${method}'"

    adb shell "su -c 'if [ -e ${DAEMON_PATH}/passwd ]; then ${PASS_CMD}; else ${NOPASS_CMD}; fi'"
}

restart_server() {
    kill_server
    start_server
}

while getopts ":s:m:" opt; do
    case $opt in
        s  ) scale=$OPTARG ;;
        m  ) method=$OPTARG ;;
        \? ) echo $usage
            exit 1 ;;
    esac
done

shift $(($OPTIND - 1))
if [ -z "$@" ]; then
    echo $usage
    exit 1
else
    action=$@
fi

case $action in
    start   ) start_server ;;
    stop  ) kill_server ;;
    restart ) restart_server ;;
          * ) echo "$0: unknown action. Use [stop|start|restart]"
          exit 1 ;;
esac
