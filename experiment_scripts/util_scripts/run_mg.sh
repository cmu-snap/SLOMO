#!/bin/bash

rate=${1}
pkt_size=${2}
competitors=${3}

echo "Starting MoonGen on traffic generator"

sudo /root/MoonGen/build/MoonGen /root/MoonGen/examples/traffic_generation.lua 0 0  -r ${rate} -s ${pkt_size} -n ${competitors} > perf_data_${competitors}.txt &
