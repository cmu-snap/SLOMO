#!/bin/bash

echo "Stopping NFs on test node"
sudo -S killall -q -9 pcm
sudo -S killall -q -9 click
sudo -S killall -q -9 snort
sudo -S killall -q -9 Suricata

exit
