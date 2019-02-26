#!/bin/bash
# Launch python3 http server ip address and capture process id
python3 -m http.server & SERVER_PID=$!
export SERVER_IP=`ifconfig docker0 | grep 'inet\s' | awk '{print $2}'`