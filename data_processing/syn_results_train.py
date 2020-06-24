import sys
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D
from sklearn.feature_selection import mutual_info_regression
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.model_selection import train_test_split
from sklearn.neighbors import NearestNeighbors
from sklearn.linear_model import LinearRegression
import pickle


nf=sys.argv[1]
pkt_size = sys.argv[2]
flow_size = sys.argv[3]

try:
    sens_models = pickle.load(open('sensitivity_dictionary.p', 'rb'))
except:
    sens_models = {}
all_counters = []

for size in ["2000000", "4000000","6000000", "8000000", "10000000", "15000000", "20000000"]:
        for itr in ["1", "2", "5", "10"]:
            for reads in ["10000", "1000"]:
                for descriptor in ["1", "2", "3", "4", "5", "6", "7"]:
                    pps = []
                    bps = []
                    try:
                        f = open('experiment_data_'+ nf +'/perf_data_'+ pkt_size + '_' + flow_size+ "_" + descriptor+'_'+size +'_' + reads + '_'+itr+'.txt','r')
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
                                print(seconds)
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
                        mean_pps = pax/seconds #float(last_lines.strip().split(":")[1].strip())
                        mean_bps = pax/seconds #float(last_lines.strip().split(":")[1].strip())
        
                    top_line = pd.read_csv('experiment_data_'+ nf +'/counters_before_' + pkt_size + '_' + flow_size+ "_"+ descriptor + '_' + size + '_'+ reads +'_' + itr +'.csv', header=None).ix[0]
                    headers = []
                    tmp = ""
                    for itm in top_line:
                        if pd.isnull(itm):
                            headers.append(tmp)
                        else:
                            tmp = itm
                            headers.append(tmp)
        
                    if descriptor == "0":
                        counters = pd.read_csv('experiment_data_'+ nf +'/counters_after_' + pkt_size + '_' + flow_size+ "_"+ descriptor + '.csv', header=[1]).tail(10).ix[:, :len(headers)]
                    else:
                        counters = pd.read_csv('experiment_data_'+ nf +'/counters_before_' + pkt_size + '_' + flow_size+ "_"+ descriptor + '_' + size + '_'+ reads +'_' + itr + '.csv', header=[1]).tail(10).ix[:, :len(headers)]
        
                    line2 = counters.columns.values
         
                    final = []
                    for itm in range(len(headers)):
                        final.append(headers[itm] + " -> " + str(line2[itm]))
                  
                    final = np.asarray(final) 
                    counters.columns = final
        
                    if nf != "Suricata" and nf != "Snort":
                        counters['Perf'] = np.asarray(pps)[:len(counters)]
                    else:
                        perf = [mean_pps for x in range(len(counters))]
                        counters['Perf'] = np.asarray(perf)                    
                    all_counters.append(counters[:-2])
            
total_vector = pd.concat(all_counters)

X_train_dobrescu = total_vector.filter(regex=("Socket1 -> L2MISS.2")).reset_index( drop=True)
X_train_mars = total_vector.filter(regex=("Socket1 -> L3OCC.1")).reset_index(drop=True)
X_train_slomo = total_vector.filter(regex=("Socket1 -> *")).reset_index( drop=True)
Y_train = total_vector['Perf'].reset_index()['Perf']

dobrescu_reg1 = LinearRegression()
mars_reg1 = LinearRegression()
slomo_reg1 = GradientBoostingRegressor()

dobrescu_reg1.fit(X_train_dobrescu, Y_train)
mars_reg1.fit(X_train_mars, Y_train)
slomo_reg1.fit(X_train_slomo, Y_train)

sens_models[(nf, pkt_size, flow_size)] = {"slomo": slomo_reg1, "dobrescu":dobrescu_reg1, "mars":mars_reg1}
pickle.dump(sens_models, open('sensitivity_dictionary.p', 'wb'))
