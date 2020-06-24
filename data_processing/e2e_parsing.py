import sys, os, pickle
import pandas as pd 
import numpy as np
from math import *

import warnings
warnings.filterwarnings("ignore")

columns = ["EXEC", "IPC", "FREQ", "AFREQ", "L3MISS", "L2MISS", "L3HIT", "L2HIT", "L3MPI", "L2MPI", "L3OCC", "LMB", "RMB", "READ", "WRITE"]
nf = sys.argv[1]
pkt = sys.argv[2]
flow_counter = sys.argv[3]

cont_dict = pickle.load(open('../all_synthetic_data/contention_dictionary.p', 'rb'))
sens_model = pickle.load(open('../all_synthetic_data/sensitivity_dictionary.p', 'rb'))
occupancies = pickle.load(open('occupancies.p', 'rb'))
solo_perf = pickle.load(open('solo_perf.p', 'rb'))
car = pickle.load(open('car.p', 'rb'))
errors = []

try:
    all_results = pickle.load(open('e2e_results.p', 'rb'))
except FileNotFoundError:
    all_results = {}

# Read list of competing NFs
for directory in os.listdir('experiment_real_data_' + nf):
    split_name = directory.strip().split("_")
    if pkt not in split_name:
        continue
    if flow_counter not in split_name:
        continue

    competing_nfs = []
    nr_competitors = 0

    try:
        f = open('experiment_real_data_'+ nf +'/' + directory + '/competitors.txt', 'rb')
    except FileNotFoundError:
        print("File not found")
        continue

    for line in f:
        comp = line.decode('UTF-8').strip()
        competing_nfs.append(comp) 
        nr_competitors += 1
    f.close()
  
    nr_competitors = str(nr_competitors)
    competing_nfs = competing_nfs

    if nf not in all_results.keys():
        all_results[nf] = {}
        all_results[nf][pkt] = {}
        all_results[nf][pkt][flow_counter] = {"1":{}, "2":{}, "3":{}, "4":{}, "5":{}, "6":{}, "7":{}}
    elif pkt not in all_results[nf].keys():
        all_results[nf][pkt] = {}
        all_results[nf][pkt][flow_counter] = {"1":{}, "2":{}, "3":{}, "4":{}, "5":{}, "6":{}, "7":{}}
    elif flow_counter not in all_results[nf][pkt].keys():
        all_results[nf][pkt][flow_counter] = {"1":{}, "2":{}, "3":{}, "4":{}, "5":{}, "6":{}, "7":{}}
  
    f = open('experiment_real_data_'+ nf +'/' + directory + '/target.txt', 'rb')
    for line in f:
        tNF = line.decode('UTF-8').strip()
    f.close()

    for filename in os.listdir('experiment_real_data_'+ nf +'/' + directory):
        if 'perf_data' in filename:
            f = open('experiment_real_data_'+ nf +'/' + directory + '/' + filename)
            if nf != "Snort" and nf != "Suricata":
                pps = []
                bps = []
                last_lines = f.readlines()[-42:]
                lines = last_lines[:-2][::2]
                last_lines = last_lines[-2:]
                for line in lines:
                    pps.append(float(line.strip().split(":")[2].split(",")[0].strip().split(" ")[0]))
                f.close()
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
                pps = [pax/seconds]
                bps = [bts/seconds]
            else:
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
                pps = [pax/seconds]
                bps = [pax/seconds]
        elif 'counters_before' in filename:
            top_line = pd.read_csv('experiment_real_data_'+ nf +'/' + directory + '/' + filename, header=None).ix[0]
            headers = []
            tmp = ""
            for itm in top_line:
                if pd.isnull(itm):
                    headers.append(tmp)
                else:
                    tmp = itm
                    headers.append(tmp)
           
            counters = pd.read_csv('experiment_real_data_'+ nf +'/' + directory + '/' + filename, header=[1]).tail(10).ix[:, :len(headers)]
            line2 = counters.columns.values

            final = []
            for itm in range(len(headers)):
                final.append(headers[itm] + " -> " + str(line2[itm]))

            final = np.asarray(final)
            counters_after = pd.read_csv('experiment_real_data_'+ nf +'/' + directory + '/' + filename, header=[1]).tail(10).ix[:, :len(headers)]
            counters_after.columns = final
            counters_after = counters_after.filter(regex=("Socket1")).reset_index(drop=True)            
            counters_after.columns = ["EXEC", "IPC", "FREQ", "AFREQ", "L3MISS", "L2MISS", "L3HIT", "L2HIT", "L3MPI", "L2MPI", "L3OCC", "LMB", "RMB", "READ", "WRITE", "TEMP"]

  
    # Compose contentiousness
    vector = cont_dict[(nf, pkt, flow_counter)]
    aggregate_cont_solo = []
    aggregate_cont = []
    counter = 0
    occupancy_of_competition = 0
    occupancy_of_target = occupancies[nf][pkt][flow_counter]
    car_solo_competition = 0
    for cNF in competing_nfs: 
        occupancy_of_competition += occupancies[nf][pkt][flow_counter]
        car_solo_competition += car[nf][pkt][flow_counter]

    for cNF in competing_nfs:
        cNF_cont_solo = vector["0"].median()
        cNF_cont = vector[nr_competitors].median()
        if counter == 0:
            aggregate_cont = cNF_cont
            aggregate_cont_solo = cNF_cont_solo
            counter += 1
        else:
            aggregate_cont += cNF_cont
            aggregate_cont_solo += cNF_cont_solo
            counter += 1
        
    aggregate_cont = pd.DataFrame(aggregate_cont.values.reshape(1,-1), columns=columns)
    aggregate_cont['IPC'] = aggregate_cont['IPC'].div(int(nr_competitors))
    aggregate_cont['EXEC'] = aggregate_cont['EXEC'].div(8)
    aggregate_cont['AFREQ'] = aggregate_cont['AFREQ'].div(int(nr_competitors))
    aggregate_cont['FREQ'] = aggregate_cont['FREQ'].div(8)
    aggregate_cont['L2HIT'] = aggregate_cont['L2HIT'].div(int(nr_competitors))
    aggregate_cont['L3HIT'] = aggregate_cont['L3HIT'].div(int(nr_competitors))

    aggregate_cont_solo = pd.DataFrame(aggregate_cont_solo.values.reshape(1,-1), columns=columns)
    aggregate_cont_solo['IPC'] = aggregate_cont_solo['IPC'].div(int(nr_competitors))
    aggregate_cont_solo['EXEC'] = aggregate_cont_solo['EXEC'].div(8)
    aggregate_cont_solo['AFREQ'] = aggregate_cont_solo['AFREQ'].div(int(nr_competitors))
    aggregate_cont_solo['FREQ'] = aggregate_cont_solo['FREQ'].div(8)
    aggregate_cont_solo['L2HIT'] = aggregate_cont_solo['L2HIT'].div(int(nr_competitors))
    aggregate_cont_solo['L3HIT'] = aggregate_cont_solo['L3HIT'].div(int(nr_competitors))
    
    # Retrieve sensitivity function for target NF
    tNF = (nf, pkt, flow_counter)
    model = sens_model[tNF]['slomo']
    dobrescu_model = sens_model[tNF]['dobrescu']
    mars_model = sens_model[tNF]['mars']

    #Make predictions
    dobrescu_result = dobrescu_model.predict(np.asarray([car_solo_competition]).reshape(-1, 1))[0]
    mars_result = mars_model.predict(aggregate_cont['L3OCC'].reshape(-1, 1))[0]

    result = model.predict(aggregate_cont)[0]
    result_no_comp = model.predict(counters_after)[0] 
    result_bad_composition = model.predict(aggregate_cont_solo)[0] 
    observed = np.mean(np.asarray(pps))

    local_errors = []
    local_errors_nc = []
    local_errors_bc = []
    local_errors_dobrescu = []
    local_errors_mars = []

    local_abs_errors = []
    local_abs_errors_nc = []
    local_abs_errors_bc = []
    local_abs_errors_dobrescu = []
    local_abs_errors_mars = []

    for x in pps:
       abs_error = abs(100*(result- x)/x)
       error = 100*(result- x)/x

       abs_nc_error = abs(100*(result_no_comp - x)/x)
       nc_error = 100*(result_no_comp - x)/x

       abs_bc_error = abs(100*(result_bad_composition - x)/x)
       bc_error = 100*(result_bad_composition - x)/x

       dobrescu_abs_error = abs(100*(dobrescu_result- x)/x)
       dobrescu_error = 100*(dobrescu_result- x)/x

       mars_abs_error = abs(100*(mars_result- x)/x)
       mars_error = 100*(mars_result- x)/x

       local_abs_errors.append(abs_error)
       local_abs_errors_nc.append(abs_nc_error)
       local_abs_errors_bc.append(abs_bc_error)
       local_abs_errors_dobrescu.append(dobrescu_abs_error)      
       local_abs_errors_mars.append(mars_abs_error)
 
       local_errors.append(error)
       local_errors_nc.append(nc_error)
       local_errors_bc.append(bc_error)
       local_errors_dobrescu.append(dobrescu_error)      
       local_errors_mars.append(mars_error)

    print("Prediction: ", result)
    print("Prediction NC ", result_no_comp)
    print("Dobrescu Prediction: ", dobrescu_result)
    print("Observed: ", observed) 
    print("Error: ", np.asarray(local_errors).mean())
    print("NC Error ", np.asarray(local_errors_nc).mean())
    print("BC Error ", np.asarray(local_errors_bc).mean())
    print("Dobrescu Error ", np.asarray(local_errors_dobrescu).mean())
    
    all_results[nf][pkt][flow_counter][nr_competitors] = {"slomo_prediction": result, 
                                                          "dobrescu_prediction": dobrescu_result, 
                                                          "mars_prediction": mars_result,
                                                          "observed": pps, 
                                                          "slomo_abs_error": local_abs_errors, "slomo_error":local_errors,
                                                          "nc_abs_error": local_abs_errors_nc, "nc_error": local_errors_nc,
                                                          "dobrescu_abs_error": local_abs_errors_dobrescu, "dobrescu_error":local_errors_dobrescu,
                                                          "mars_abs_error": local_abs_errors_mars, "mars_error": local_errors_mars}

pickle.dump(all_results, open('e2e_results.p', 'wb'))
