#!/bin/bash

for i in 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
do
    echo 0 > /sys/devices/system/cpu/cpu${i}/online
done


~/dpdk-stable-18.05.1/usertools/dpdk-devbind.py -b i40e 0000:8a:00.0
echo 8 > /sys/bus/pci/devices/0000\:8a\:00.0/sriov_numvfs
modprobe uio
modprobe vfio
modprobe vfio-pci
modprobe msr
insmod ~/dpdk-stable-18.05.1/build/kmod/igb_uio.ko

ip link set ens11 vf 0 mac 52:67:f7:65:74:e2
ip link set ens11 vf 1 mac b2:85:38:6e:df:bc
ip link set ens11 vf 2 mac ee:14:a4:5f:dc:f6
ip link set ens11 vf 3 mac ee:c4:fd:68:14:c4
ip link set ens11 vf 4 mac b2:a6:35:6f:e6:c7
ip link set ens11 vf 5 mac 4a:50:54:ed:de:76
ip link set ens11 vf 6 mac 8e:69:26:d2:c3:30
ip link set ens11 vf 7 mac 86:b3:7b:e0:31:65
ip link set ens11 up

~/dpdk-stable-18.05.1/usertools/dpdk-devbind.py -b igb_uio 0000:8a:02.0
~/dpdk-stable-18.05.1/usertools/dpdk-devbind.py -b igb_uio 0000:8a:02.1
~/dpdk-stable-18.05.1/usertools/dpdk-devbind.py -b igb_uio 0000:8a:02.2
~/dpdk-stable-18.05.1/usertools/dpdk-devbind.py -b igb_uio 0000:8a:02.3
~/dpdk-stable-18.05.1/usertools/dpdk-devbind.py -b igb_uio 0000:8a:02.4
~/dpdk-stable-18.05.1/usertools/dpdk-devbind.py -b igb_uio 0000:8a:02.5
~/dpdk-stable-18.05.1/usertools/dpdk-devbind.py -b igb_uio 0000:8a:02.6
~/dpdk-stable-18.05.1/usertools/dpdk-devbind.py -b igb_uio 0000:8a:02.7
~/dpdk-stable-18.05.1/usertools/dpdk-devbind.py -s

echo 10 > /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
