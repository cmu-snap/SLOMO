#!/bin/bash

echo "Stopping NFs on testing node"
sudo pkill pcm
sleep 1
sudo killall -q -9 click
sudo killall -q -9 NetBricks
sudo pkill ${1}

exit
