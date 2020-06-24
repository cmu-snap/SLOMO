#!/bin/bash

competitors=${1}
size=${2}
reads=${3}
iter=${4}

echo "Starting Experiment on Radish"
if [ ${competitors} -eq 0 ]
then
    echo "Do nothing"

elif [ ${competitors} -eq 1 ]
then
     sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4  --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/syn_conf/syn_conf.click SIZE=${size} READS=${reads} ITERS=${iter}  &    

elif [ ${competitors} -eq 2 ]
then
     sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4 --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/syn_conf/syn_conf.click SIZE=${size} READS=${reads} ITERS=${iter}  &
     sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4 --file-prefix=app6 -w 0000:8b:02.1 -- /root/click/conf/syn_conf/syn_conf.click SIZE=${size} READS=${reads} ITERS=${iter}  &

elif [ ${competitors} -eq 3 ]
then 
     sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4 --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/syn_conf/syn_conf.click SIZE=${size} READS=${reads} ITERS=${iter}  &
     sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4 --file-prefix=app6 -w 0000:8b:02.1 -- /root/click/conf/syn_conf/syn_conf.click SIZE=${size} READS=${reads} ITERS=${iter}  &
     sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 14 -n 4 --file-prefix=app7 -w 0000:8b:02.2 -- /root/click/conf/syn_conf/syn_conf.click SIZE=${size} READS=${reads} ITERS=${iter}  &

elif [ ${competitors} -eq 4 ]
then    
     sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4 --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/syn_conf/syn_conf.click SIZE=${size} READS=${reads} ITERS=${iter}  &
     sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4 --file-prefix=app6 -w 0000:8b:02.1 -- /root/click/conf/syn_conf/syn_conf.click SIZE=${size} READS=${reads} ITERS=${iter}  &
     sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 14 -n 4 --file-prefix=app7 -w 0000:8b:02.2 -- /root/click/conf/syn_conf/syn_conf.click SIZE=${size} READS=${reads} ITERS=${iter}  &
     sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 15 -n 4 --file-prefix=app8 -w 0000:8b:02.3 -- /root/click/conf/syn_conf/syn_conf.click SIZE=${size} READS=${reads} ITERS=${iter}  &

elif [ ${competitors} -eq 5 ]
then
    for iters in 1 2 3 4 5
    do
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 9 -n 4   --file-prefix=app2  -w 0000:8a:02.1 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app3  -w 0000:8a:02.2 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4  --file-prefix=app4  -w 0000:8a:02.3 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4  --file-prefix=app5  -w 0000:8b:02.0 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4  --file-prefix=app6  -w 0000:8b:02.1 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
    done

elif [ ${competitors} -eq 6 ]
then
    for iters in 1 2 3 4 5
    do
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 9 -n 4   --file-prefix=app2  -w 0000:8a:02.1 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app3  -w 0000:8a:02.2 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4  --file-prefix=app4  -w 0000:8a:02.3 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4  --file-prefix=app5  -w 0000:8b:02.0 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4  --file-prefix=app6  -w 0000:8b:02.1 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 14 -n 4  --file-prefix=app7  -w 0000:8b:02.2 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
    done

elif [ ${competitors} -eq 7 ]
then
    for iters in 1 2 3 4 5
    do
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 9 -n 4   --file-prefix=app2  -w 0000:8a:02.1 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app3  -w 0000:8a:02.2 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4  --file-prefix=app4  -w 0000:8a:02.3 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4  --file-prefix=app5  -w 0000:8b:02.0 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4  --file-prefix=app6  -w 0000:8b:02.1 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 14 -n 4  --file-prefix=app7  -w 0000:8b:02.2 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
             sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 15 -n 4  --file-prefix=app8  -w 0000:8b:02.3 -- /root/click/conf/syn/syn.click SIZ=${size} READ=${reads} ITER=${iter}  &
    done
fi

sleep 2
echo "Starting Intel pcm" 
 sudo -S numactl -m 1 /root/pcm/pcm.x -r -csv=counters_before_${competitors}.csv &
