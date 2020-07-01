#!/bin/bash

nf=${1}
competitors=${2}

echo "Starting Experiment on testing node"
if [ "${nf}" != "Suricata" ] && [ "${nf}" != "Snort" ] && [ "${nf}" != "maglev" ]
then 
    sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 8 -n 4  --file-prefix=app1 -w 0000:8a:02.0 -- /root/click/conf/${nf}/${nf}.click  &
        sleep 2

elif [ "${nf}" == "Suricata" ]
then
   sudo -S rm /usr/local/var/log/suricata/stats_*
   sudo -S rm /usr/local/var/log/suricata/eve*.json
   sudo -S numactl -m 1 /root/new_suricata/DPDK-Suricata_3.0/suricata_1/src/suricata -c /root/new_suricata/DPDK-Suricata_3.0/suricata_1/suricata.yaml --dpdkintel  &

elif [ "${nf}" == "Snort" ]
then
   sudo -S bash /root/intel_snort/snort3/run_snort.sh "8" "app1" "0000:8a:02.0"  &
   sleep 2
 
elif [ "${nf}" == "maglev" ]
then
   sudo -S numactl -m 1 -N 1 -- bash /root/NetBricks/build.sh run maglev -f /root/NetBricks/config.toml &
   sleep 2
fi

sleep 2
echo "Starting Intel pcm" 
sudo -S numactl -m 1 /root/pcm/pcm.x -r -csv=counters_after_${competitors}.csv &
