#!/bin/bash


rate=${1}
pkt_size=${2}
compet=${3}

echo "Starting MoonGen on traffic generator"
sudo /root/MoonGen2/build/MoonGen /root/MoonGen2/examples/traffic_generation.lua 0 0  -r ${rate} -s ${pkt_size} -n ${compet} > perf_data_competition.txt &
 
