#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar  7 15:33:05 2023

@author: lauri
"""

import pandas as pd
import os
import sys

output_folder = ''
#output_folder = '/home/lauri/Desktop/Twist_Solid-0.6.1/'
#directory = output_folder+'/results/dna/'
sample_path = output_folder+'samples.tsv'

df_samples = pd.read_csv(sample_path, sep='\t')
# df_samples = df_samples.set_index('sample')
# df_samples_index = df_samples.index.name
columns = df_samples.columns.tolist()
df_samples_index = columns[0]

#df_sheet = '/data/Twist_Solid/DNA/input/automate/run2/SampleSheet.csv'

path = sys.argv[1]
#path = "/data/Twist_Solid/DNA/input/230531_test"


if os.path.isfile(path+'/SampleSheet.csv') :
    df_sheet = path+'/SampleSheet.csv'
    with open(df_sheet, "r") as f:
        results = f.readlines()

    test_list = []

    for row in results:
        if 'Sample' in row:
            index = results.index(row)
        
    test = results[index:]

    for row in test:
        test_list.append(row.split(','))


    df_sheet = pd.DataFrame(test_list)
    df_sheet.columns = df_sheet.iloc[0]
    df_sheet = df_sheet.tail(-1)
    df_sheet = df_sheet.rename(columns = {'Sample_Name': df_samples_index})
    df_sheet = df_sheet.set_index(df_samples_index)

    df_sheet_tumor = pd.to_numeric(df_sheet['Description\n']).to_frame()
    df_sheet_tumor = df_sheet_tumor.rename(columns = {'Description\n' : columns[1]})

    df_sheet_tumor.to_csv(output_folder+'samples.tsv', sep='\t')




        
        