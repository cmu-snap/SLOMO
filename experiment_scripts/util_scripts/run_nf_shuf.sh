#!/bin/bash

competitors=${1}
list_comp=("ip_131k" "mon_dpdk" "vpn" "fw_1000")

echo "Starting Experiment on testing node"
echo "" > competitors.txt
if [ ${competitors} -eq 1 ]
then
    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 9 -n 4  --file-prefix=app2 -w 0000:8a:02.1 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click  &

elif [ ${competitors} -eq 2 ]
then

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app2 -w 0000:8a:02.1 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click  &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4  --file-prefix=app3 -w 0000:8a:02.2 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click  &

elif [ ${competitors} -eq 3 ]
then 

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app2 -w 0000:8a:02.1 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4  --file-prefix=app3 -w 0000:8a:02.2 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt    
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4 --file-prefix=app4 -w 0000:8a:02.3 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

elif [ ${competitors} -eq 4 ]
then
    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app2 -w 0000:8a:02.1 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4  --file-prefix=app3 -w 0000:8a:02.2 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt    
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4 --file-prefix=app4 -w 0000:8a:02.3 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt    
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4 --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click  &

elif [ ${competitors} -eq 5 ]
then
    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app2 -w 0000:8a:02.1 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`1
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4  --file-prefix=app3 -w 0000:8a:02.2 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt    
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4 --file-prefix=app4 -w 0000:8a:02.3 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt    
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4 --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click  &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt        
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 14 -n 4 --file-prefix=app6 -w 0000:8b:02.1 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click  &

elif [ ${competitors} -eq 6 ]
then
    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app2 -w 0000:8a:02.1 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4  --file-prefix=app3 -w 0000:8a:02.2 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt    
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4 --file-prefix=app4 -w 0000:8a:02.3 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt    
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4 --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click  &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt        
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 14  -n 4 --file-prefix=app6 -w 0000:8b:02.1 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click  &
    
    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt        
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 15 -n 4 --file-prefix=app7 -w 0000:8b:02.2 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click

elif [ ${competitors} -eq 7 ]
then
    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 9 -n 4  --file-prefix=app2 -w 0000:8a:02.1 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app3 -w 0000:8a:02.2 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt    
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4 --file-prefix=app4 -w 0000:8a:02.3 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt    
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4 --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &

    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt        
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4 --file-prefix=app6 -w 0000:8b:02.1 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &
    
    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt        
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 14 -n 4 --file-prefix=app7 -w 0000:8b:02.2 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &
    
    index=`shuf -i 0-3 -n 1`
    echo ${list_comp[${index}]} >> competitors.txt        
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 15 -n 4 --file-prefix=app8 -w 0000:8b:02.3 -- /root/click/conf/${list_comp[${index}]}/${list_comp[${index}]}.click &
fi

sleep 2
echo "Starting Intel pcm" 
sudo -S numactl -m 1 /root/pcm/pcm.x -r -csv=counters_before_${competitors}.csv &
