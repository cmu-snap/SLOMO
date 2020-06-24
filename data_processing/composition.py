import sys
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import pickle
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D
from sklearn.feature_selection import mutual_info_regression
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.model_selection import train_test_split
from sklearn.neighbors import NearestNeighbors
from sklearn.linear_model import LinearRegression


nf=sys.argv[1]
pkt_size = sys.argv[2]
flow_count = sys.argv[3]

try:
    cont_dict = pickle.load(open('contention_dictionary.p', 'rb'))
except:
    cont_dict = {}

cont_dict[(nf, pkt_size, flow_count)] = {}
for competitor in ["0", "1", "2", "3", "4", "5", "6", "7", "8"]:
    all_counters = []
    all_counters_solo = []
    for itr in ["1", "2", "5", "10"]:
        for reads in ["10000", "5000", "1000"]:
            for size in ["2000000", "4000000","6000000", "8000000", "10000000", "15000000", "20000000"]:
                pps = []
                bps = []
                try:
                    if competitor == "0":
                        f = open('experiment_data_'+ nf +'/perf_data_'+ pkt_size + '_' +competitor+'.txt','r')
                    else:
                        f = open('experiment_data_'+ nf +'/perf_data_'+ pkt_size + '_' + flow_count + '_' + competitor+'_'+size +'_' + reads + '_'+itr+'.txt','r')
                except FileNotFoundError:
                    continue

                if nf != "Suricata" and nf != "Snort":
                    last_lines = f.readlines()[-22:]
                    f.close()
                    if len(last_lines) < 3:
                        continue
                    if "RX" in last_lines[-3]:
                        lines = last_lines[1:-2][::2]
                        lines[-1] = lines[-2]
                    else:            
                        lines = last_lines[:-2][::2]
                       
                    for line in lines: 
                        pps.append(float(line.strip().split(":")[2].split(",")[0].strip().split(" ")[0]))
                        bps.append(float(line.strip().split(":")[2].split(",")[1].strip().split(" ")[0])) 

                elif nf == "Suricata":
                    last_lines = f.readlines()[-25:]
                    f.close()
        
                    flag = False
                    for line in last_lines:
                        if 'decoder.pkts' in line:
                            pax = float(line.strip().split("|")[2].strip())
                            flag = True
                        elif 'decoder.bytes' in line:
                            bts = float(line.strip().split("|")[2].strip())
                            flag = True
                        elif 'uptime' in line:
                            seconds = float(line.strip().split(",")[1].strip().split(" ")[-1][:-2].strip())

                    if not flag:
                        continue
                    mean_pps = pax/seconds
                    mean_bps = bts/seconds
        
                elif nf == "Snort":
                    last_lines = f.readlines()[-70:]
                    f.close()
    
                    flag = False
                    for line in last_lines:
                        if 'analyzed' in line:
                            pax = float(line.strip().split(":")[1].strip())
                            flag = True
                        if 'seconds' in line:
                            seconds = float(line.strip().split(":")[1].strip())
    
                    if not flag:
                        continue
                    mean_pps = pax/seconds 
                    mean_bps = pax/seconds
    

                if competitor == "0":
                    top_line = pd.read_csv('experiment_data_'+ nf +'/counters_after_'  + pkt_size + '_' + flow_count  + '_' + competitor + '.csv', header=None).ix[0]
                else:
                    top_line = pd.read_csv('experiment_data_'+ nf +'/counters_before_' + pkt_size + '_' + flow_count + '_' + competitor + '_' + size + '_'+ reads +'_' + itr +'.csv', header=None).ix[0]
                headers = []
                tmp = ""
                for itm in top_line:
                    if pd.isnull(itm):
                        headers.append(tmp)
                    else:
                        tmp = itm
                        headers.append(tmp)
    
                if competitor == "0":
                    counters_solo = pd.read_csv('experiment_data_'+ nf +'/counters_after_' + pkt_size + '_' + flow_count + '_' + competitor + '.csv', header=[1]).tail(10).ix[:, :len(headers)]
                    line2 = counters_solo.columns.values
                else:
                    counters = pd.read_csv('experiment_data_'+ nf +'/counters_before_' + pkt_size + '_' + flow_count + '_' + competitor + '_' + size + '_'+ reads +'_' + itr + '.csv', header=[1]).tail(10).ix[:, :len(headers)]
                    line2 = counters.columns.values
     
                final = []
                for itm in range(len(headers)):
                    final.append(headers[itm] + " -> " + str(line2[itm]))
              
                final = np.asarray(final) 
                if competitor == "0":
                    counters_solo.columns=final
                else:
                    counters.columns = final
 
                if competitor != "0": 
                    counters_after = pd.read_csv('experiment_data_'+ nf +'/counters_after_' + pkt_size + '_' + flow_count + '_' + competitor + '_' + size + '_'+ reads +'_' + itr + '.csv', header=[1]).tail(10).ix[:, :len(headers)]
                    counters_after.columns = final

                    diff_mem = (counters_after.filter(regex=("Socket1")).reset_index(drop=True)).subtract(counters.filter(regex=("Socket1")).reset_index(drop=True)) 
                    diff_mem_read = diff_mem.filter(regex=("READ")).reset_index(drop=True)
                    diff_mem_write = diff_mem.filter(regex=("WRITE")).reset_index(drop=True)
                    diff_mem_read.columns = ["READ"]
                    diff_mem_write.columns= ["WRITE"]

                    counters = counters.filter(regex=("Core1 ")).reset_index(drop=True)
                    counters_after = counters_after.filter(regex=("Core1 ")).reset_index(drop=True)

                    diff = counters_after
                    diff["READ"] = diff_mem_read 
                    diff["WRITE"] = diff_mem_write

                    all_counters.append(diff[:-5])
                if competitor == "0":
                    counters_solo = counters_solo.filter(regex=("Core1 ")).reset_index(drop=True)
                    all_counters_solo.append(counters_solo[:-8])
          
    try:
        total_vector = pd.concat(all_counters)
    except:
        continue

    df = total_vector
    df.columns = ["EXEC", "IPC", "FREQ", "AFREQ", "L3MISS", "L2MISS", "L3HIT", "L2HIT", "L3MPI", "L2MPI", "L3OCC", "LMB", "RMB", "READ", "WRITE"]

    normalized_df= df
    normalized_df = normalized_df.melt(var_name='groups', value_name='vals')
    cont_dict[(nf, pkt_size, flow_count)][competitor] = df

pickle.dump(cont_dict, open("contention_dictionary.p", "wb"))
