#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar  1 14:05:01 2023

@author: lauri
"""

import pandas as pd
import os
import sys

output_folder = sys.argv[1]
#output_folder = '/home/lauri/Desktop/Twist_Solid-0.4.0/2023-03-03_run1'
directory = output_folder+'/results/dna/'
sample_path = output_folder+'/samples.tsv'

tmb_path = 'tmb/'
hrd_path = 'hrd/'
msi_path = 'msi/'
fusion_path = 'fusion/'

paths = [directory+tmb_path, directory+hrd_path, directory+msi_path, directory+fusion_path]

df_samples = pd.read_csv(sample_path, sep = '\t')
samples = list(df_samples['sample'])

hrd_column = 'HRD-score'
msi_column = 'msi score (%)'
tmb_column = 'nsSNV TMB (mutations/mb)'
fusion = 'Gene fusions'


msi = []
result_list = []
hrd = []
tmb = []
fusions = []
for path in paths:
    for files in os.listdir(path):
        sample = files.split('.')[0]
        if 'msi' in path:
            df = pd.read_csv(path+files, sep = '\t')
            df['Sample'] = sample
            columns = df.columns
            columns = columns.tolist()
            msi.append(df.values.tolist()[0])
        if 'fusion' in path and '.tsv' in files:
            df = pd.read_csv(path+files, sep = '\t')
            if df.empty:
                fusion_dict = {'Sample' : sample, 'Fusions' : 'No'}
            else:
                fusion_dict = {'Sample' : sample, 'Fusions' : 'Yes'}
            fusions.append(fusion_dict)
            
        if 'tmb' or 'hrd' in path:
            with open(path+files, "r") as f:
                results = f.readlines()[0:5]
        if 'tmb' in path:
            results2 = float(results[0].split('\t')[1])
            tmb_dic = {'Sample': sample, tmb_column: results2}
            tmb.append(tmb_dic)
        elif 'hrd' in path and 'purecn' not in files:
            results2 = results
            columns = results2[0].split('\t')
            results3 = results2[1].split('\t')
            hrd_dic = {'Sample' : sample, columns[0]: results3[0], columns[1] : results3[1], 
                       columns[2] : results3[2], columns[3] : results3[3]}
            hrd.append(hrd_dic)



if len(hrd) == len(tmb):
    for i in range(len(hrd)):
        sample_hrd = hrd[i].get("Sample")
        for j in range(len(tmb)):
            if tmb[j].get("Sample") == sample_hrd:
                hrd[i].update(tmb[j])
            if fusions[j].get("Sample") == sample_hrd:
                hrd[i].update(fusions[j])
        result_list.append(hrd[i])
        
        
df_msi = pd.DataFrame(msi, columns = columns)
df_msi = df_msi.set_index('Sample')        

df_test = pd.DataFrame(result_list)
df_test = df_test.set_index('Sample')

df_test = pd.concat([df_test, df_msi], axis=1)
df_test = df_test.sort_index()
df_test_s = df_test[[tmb_column, 'HRD-score', '%', 'Fusions']]
df_test_s.columns = df_test_s.columns.str.replace('%', msi_column)

df_test_s.to_csv(directory+'biomarkers_and_fusion.tsv', sep = '\t', encoding = 'utf8')
df_test.to_csv(directory+'biomarkers_and_fusion_extended.tsv', sep = '\t', encoding = 'utf8')
        
        
