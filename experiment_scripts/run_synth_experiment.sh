#!/bin/bash

rate=40000
packet_size=80

for tNF_packet_size in 64 500 1500
do
    for nf_type in mon_dpdk vpn mon_dpdk Suricata Snort maglev 
    do
        mkdir experiment_data_${nf_type}
        for nr_competitors in 1 2 3 4 5 6 7  
        do
            if [ ${nr_competitors} -eq 0  ]
            then
                    ssh -tt node0 'bash -s' < ./util_scripts/cleanup_nf.sh  &
                    sleep 5
                    ssh -tt node0 'bash -s' < ./util_scripts/stop_pcm.sh
                    ssh -tt node1 'bash -s' < ./util_scripts/run_mg.sh "${rate}" "${tNF_packet_size}" "${nr_competitors}" &
                    ssh -tt node0 'bash -s' < ./util_scripts/run_nf.sh "${nf_type}" "${nr_competitors}"  &
                    sleep 30

                    ssh -tt node1 'bash -s' < ./util_scripts/stop_mg.sh
                    if [ "${nf_type}" != "Suricata" ] && [ "${nf_type}" != "Snort" ] 
                    then
                        ssh -tt node0 'bash -s' < ./util_scripts/stop_nf.sh "click"
                        sleep 5
                        scp node1:perf_data_${nr_competitors}.txt ./experiment_data_${nf_type}/perf_data_${tNF_packet_size}_${nr_competitors}.txt
                        scp node0:counters_before_${nr_competitors}.csv  ./experiment_data_${nf_type}/counters_before_${tNF_packet_size}_${nr_competitors}.csv
                        scp node0:counters_after_${nr_competitors}.csv   ./experiment_data_${nf_type}/counters_after_${tNF_packet_size}_${nr_competitors}.csv
                    elif [ "${nf_type}" == "Suricata" ]
                    then
                        ssh -tt node0 'bash -s' < ./util_scripts/stop_nf.sh "Suricata"
                        sleep 5
                        scp node0:/usr/local/var/log/suricata/stats_1.log ./experiment_data_${nf_type}/perf_data_${tNF_packet_size}_${nr_competitors}.txt
                        scp node0:counters_before_${nr_competitors}.csv  ./experiment_data_${nf_type}/counters_before_${tNF_packet_size}_${nr_competitors}.csv
                        scp node0:counters_after_${nr_competitors}.csv  ./experiment_data_${nf_type}/counters_after_${tNF_packet_size}_${nr_competitors}.csv
                    elif [ "${nf_type}" == "Snort" ]
                    then
                        ssh -tt node0 'bash -s' < ./util_scripts/stop_nf.sh "snort"
                        sleep 10
                        scp node0:output_app1.txt ./experiment_data_${nf_type}/perf_data_${tNF_packet_size}_${nr_competitors}.txt
                        scp node0:counters_before_${nr_competitors}.csv  ./experiment_data_${nf_type}/counters_before_${tNF_packet_size}_${nr_competitors}.csv
                        scp node0:counters_after_${nr_competitors}.csv  ./experiment_data_${nf_type}/counters_after_${tNF_packet_size}_${nr_competitors}.csv
                    fi 
        else
        for size in 2000000 6000000 15000000 20000000; do
            for reads in 10000 5000 1000; do 
                for iters in 1 5 10; do
                    ssh -tt node0 'bash -s' < ./util_scripts/cleanup_nf.sh  &
                    sleep 2
                    ssh -tt node1 'bash -s' < ./util_scripts/run_mg.sh "${rate}" "${tNF_packet_size}" "${nr_competitors}" &
                    ssh -tt node1 'bash -s' < ./util_scripts/run_mg_comp.sh "${rate}" "${packet_size}" "${nr_competitors}" &
                    ssh -tt node0 'bash -s' < ./util_scripts/run_nf_synth_comp.sh "${nr_competitors}" "${size}" "${reads}" "${iters}"  &
                    sleep 20

                    ssh -tt node0 'bash -s' < ./util_scripts/stop_pcm.sh
                    ssh -tt node0 'bash -s' < ./util_scripts/run_nf.sh "${nf_type}" "${nr_competitors}"  &
                    sleep 40

                    ssh -tt node1 'bash -s' < ./util_scripts/stop_mg.sh
                    if [ "${nf_type}" != "Suricata" ] && [ "${nf_type}" != "Snort" ] && [ "${nf_type}" != "maglev" ]
                    then
                        ssh -tt node0 'bash -s' < ./util_scripts/stop_nf.sh "click" 
                        sleep 5
                        scp node1:perf_data_${nr_competitors}.txt ./experiment_data_${nf_type}/perf_data_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.txt
                        scp node0:counters_before_${nr_competitors}.csv  ./experiment_data_${nf_type}/counters_before_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.csv
                        scp node0:counters_after_${nr_competitors}.csv   ./experiment_data_${nf_type}/counters_after_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.csv
                    elif [ "${nf_type}" == "Suricata" ]
                    then
                        ssh -tt node0 'bash -s' < ./util_scripts/stop_nf.sh "Suricata"
                        sleep 5
                        scp node0:/usr/local/var/log/suricata/stats_1.log ./experiment_data_${nf_type}/perf_data_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.txt
                        scp node0:counters_before_${nr_competitors}.csv  ./experiment_data_${nf_type}/counters_before_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.csv
                        scp node0:counters_after_${nr_competitors}.csv  ./experiment_data_${nf_type}/counters_after_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.csv
                    elif [ "${nf_type}" == "Snort" ]
                    then 
                        ssh -tt node0 'bash -s' < ./util_scripts/stop_nf.sh "snort"
                        sleep 10
                        scp node0:output_app1.txt ./experiment_data_${nf_type}/perf_data_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.txt
                        scp node0:counters_before_${nr_competitors}.csv  ./experiment_data_${nf_type}/counters_before_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.csv
                        scp node0:counters_after_${nr_competitors}.csv  ./experiment_data_${nf_type}/counters_after_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.csv
                    elif [ "${nf_type}" == "maglev" ]
                    then
                        ssh -tt node0 'bash -s' < ./util_scripts/stop_nf.sh "NetBricks" 
                        sleep 5
                        scp node1:perf_data_${nr_competitors}.txt ./experiment_data_${nf_type}/perf_data_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.txt
                        scp node0:counters_before_${nr_competitors}.csv  ./experiment_data_${nf_type}/counters_before_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.csv
                        scp node0:counters_after_${nr_competitors}.csv   ./experiment_data_${nf_type}/counters_after_${tNF_packet_size}_${nr_competitors}_${size}_${reads}_${iters}.csv
                    fi
               done
           done
        done
        fi
    done
done
done
