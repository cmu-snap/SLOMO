#!/bin/bash

competitors=${1}
nf=${2}

echo "Starting Experiment on test node"
if [ "${nf}" != "Suricata" ] && [ "${nf}" != "Snort" ]
then
    if [ ${competitors} -eq 0 ]
    then
        echo "Do nothing"
    
    elif [ ${competitors} -eq 1 ]
    then
        sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12  -n 4  --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/${nf}/${nf}.click   &    
    
    elif [ ${competitors} -eq 2 ]
    then
        for iters in 1 2 3 4 5
        do
            sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4 --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/${nf}/${nf}.click  &
            sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4 --file-prefix=app6 -w 0000:8b:02.1 -- /root/click/conf/${nf}/${nf}.click  &
        done    

    elif [ ${competitors} -eq 3 ]
    then 
        for iters in 1 2 3 4 5
        do
            sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4 --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/${nf}/${nf}.click  &
            sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4 --file-prefix=app6 -w 0000:8b:02.1 -- /root/click/conf/${nf}/${nf}.click  &
            sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 14 -n 4 --file-prefix=app7 -w 0000:8b:02.2 -- /root/click/conf/${nf}/${nf}.click  &
        done

    elif [ ${competitors} -eq 4 ]
    then 
        for iters in 1 2 3 4 5
        do   
            sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4 --file-prefix=app5 -w 0000:8b:02.0 -- /root/click/conf/${nf}/${nf}.click  &
            sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4 --file-prefix=app6 -w 0000:8b:02.1 -- /root/click/conf/${nf}/${nf}.click  &
            sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 14 -n 4 --file-prefix=app7 -w 0000:8b:02.2 -- /root/click/conf/${nf}/${nf}.click  &
            sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 15 -n 4 --file-prefix=app8 -w 0000:8b:02.3 -- /root/click/conf/${nf}/${nf}.click  &
        done

    elif [ ${competitors} -eq 5 ]
    then
        for iters in 1 2 3 4 5
        do
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 9 -n 4   --file-prefix=app2  -w 0000:8a:02.1 -- /root/click/conf/${nf}/${nf}.click  &
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app3  -w 0000:8a:02.2 -- /root/click/conf/${nf}/${nf}.click  &
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4  --file-prefix=app4  -w 0000:8a:02.3 -- /root/click/conf/${nf}/${nf}.click  &
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4  --file-prefix=app5  -w 0000:8b:02.0 -- /root/click/conf/${nf}/${nf}.click  &
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4  --file-prefix=app6  -w 0000:8b:02.1 -- /root/click/conf/${nf}/${nf}.click  &
        done
    
    elif [ ${competitors} -eq 6 ]
    then
        for iters in 1 2 3 4 5
        do
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 9 -n 4   --file-prefix=app2  -w 0000:8a:02.1 -- /root/click/conf/${nf}/${nf}.click &
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app3  -w 0000:8a:02.2 -- /root/click/conf/${nf}/${nf}.click & 
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4  --file-prefix=app4  -w 0000:8a:02.3 -- /root/click/conf/${nf}/${nf}.click & 
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4  --file-prefix=app5  -w 0000:8b:02.0 -- /root/click/conf/${nf}/${nf}.click & 
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4  --file-prefix=app6  -w 0000:8b:02.1 -- /root/click/conf/${nf}/${nf}.click & 
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 14 -n 4  --file-prefix=app7  -w 0000:8b:02.2 -- /root/click/conf/${nf}/${nf}.click & 
        done
    
    elif [ ${competitors} -eq 7 ]
    then
        for iters in 1 2 3 4 5
        do
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 9 -n 4   --file-prefix=app2  -w 0000:8a:02.1 -- /root/click/conf/${nf}/${nf}.click & 
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 10 -n 4  --file-prefix=app3  -w 0000:8a:02.2 -- /root/click/conf/${nf}/${nf}.click & 
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 11 -n 4  --file-prefix=app4  -w 0000:8a:02.3 -- /root/click/conf/${nf}/${nf}.click & 
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 12 -n 4  --file-prefix=app5  -w 0000:8b:02.0 -- /root/click/conf/${nf}/${nf}.click & 
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 13 -n 4  --file-prefix=app6  -w 0000:8b:02.1 -- /root/click/conf/${nf}/${nf}.click & 
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 14 -n 4  --file-prefix=app7  -w 0000:8b:02.2 -- /root/click/conf/${nf}/${nf}.click & 
                sudo -S numactl -m 1 /root/click/bin/click --dpdk -l 15 -n 4  --file-prefix=app8  -w 0000:8b:02.3 -- /root/click/conf/${nf}/${nf}.click & 
        done
    fi
elif [ "${nf}" == "Snort" ] 
then
    if [ ${competitors} -eq 5 ]
    then
        for iters in 1 2 3 4 5 
        do
            sudo -S bash /root/intel_snort/snort3/run_snort.sh "12" "app5" "0000:8b:02.0"  &
            sudo -S bash /root/intel_snort/snort3/run_snort.sh "13" "app6" "0000:8b:02.1"  &
        done

    elif [ ${competitors} -eq 6 ]
    then
        for iters in 1 2 3 4 5
        do
            sudo -S bash /root/intel_snort/snort3/run_snort.sh "12" "app5" "0000:8b:02.0"  &
            sudo -S bash /root/intel_snort/snort3/run_snort.sh "13" "app6" "0000:8b:02.1"  &
            sudo -S bash /root/intel_snort/snort3/run_snort.sh "14" "app7" "0000:8b:02.2"  &
        done

    elif [ ${competitors} -eq 7 ]
    then
        for iters in 1 2 3 4 5
        do
            sudo -S bash /root/intel_snort/snort3/run_snort.sh "12" "app5" "0000:8b:02.0"  &
            sudo -S bash /root/intel_snort/snort3/run_snort.sh "13" "app6" "0000:8b:02.1"  & 
            sudo -S bash /root/intel_snort/snort3/run_snort.sh "14" "app7" "0000:8b:02.2"  & 
            sudo -S bash /root/intel_snort/snort3/run_snort.sh "15" "app8" "0000:8b:02.3"  &
        done
    fi
elif [ "${nf}" == "Suricata" ]
then 
    if [ ${competitors} -eq 5 ]
    then
        for iters in 1
        do
            sudo -S rm /usr/local/var/log/suricata/stats_*
            sudo -S rm /usr/local/var/log/suricata/eve*.json
            sudo -S numactl -m 1 /root/new_suricata/DPDK-Suricata_3.0/suricata_2/src/suricata -c /root/new_suricata/DPDK-Suricata_3.0/suricata_2/suricata.yaml --dpdkintel  &
        done

    elif [ ${competitors} -eq 6 ]
    then
        for iters in 1
        do
            sudo -S rm /usr/local/var/log/suricata/stats_*
            sudo -S rm /usr/local/var/log/suricata/eve*.json
            sudo -S numactl -m 1 /root/new_suricata/DPDK-Suricata_3.0/suricata_2/src/suricata -c /root/new_suricata/DPDK-Suricata_3.0/suricata_2/suricata.yaml --dpdkintel  &
            sudo -S numactl -m 1 /root/new_suricata/DPDK-Suricata_3.0/suricata_3/src/suricata -c /root/new_suricata/DPDK-Suricata_3.0/suricata_3/suricata.yaml --dpdkintel  &
        done

    elif [ ${competitors} -eq 7 ]
    then
        for iters in 1
        do
            sudo -S rm /usr/local/var/log/suricata/stats_*
            sudo -S rm /usr/local/var/log/suricata/eve*.json
            sudo -S numactl -m 1 /root/new_suricata/DPDK-Suricata_3.0/suricata_2/src/suricata -c /root/new_suricata/DPDK-Suricata_3.0/suricata_2/suricata.yaml --dpdkintel  &
            sudo -S numactl -m 1 /root/new_suricata/DPDK-Suricata_3.0/suricata_3/src/suricata -c /root/new_suricata/DPDK-Suricata_3.0/suricata_3/suricata.yaml --dpdkintel  &
            sudo -S numactl -m 1 /root/new_suricata/DPDK-Suricata_3.0/suricata_4/src/suricata -c /root/new_suricata/DPDK-Suricata_3.0/suricata_4/suricata.yaml --dpdkintel  &
        done
    fi
fi
sleep 2
echo "Starting Intel pcm" 
sudo -S numactl -m 1 /root/pcm/pcm.x -r -csv=counters_before_${competitors}.csv &
