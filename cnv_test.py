#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr  3 10:48:25 2023

@author: lauri
"""

import matplotlib.pyplot as plt
import os
import re
import pandas as pd
import numpy as np

#path2 = '/home/lauri/Desktop/Twist_Solid-0.4.0/230331_cnv_test/results/dna/cnv/'
path2 = '/archive/Twist_Solid/DNA/results/v.0.4.0/230331_cnv_test/results/dna/cnv/'

samples = os.listdir(path2)
#samples = ['UP-2_T']
for sample in samples:
    #path = '/home/lauri/Desktop/Twist_Solid-0.4.0/230331_cnv_test/results/dna/cnv/'+sample+'/'
    path = '/archive/Twist_Solid/DNA/results/v.0.4.0/230331_cnv_test/results/dna/cnv/'+sample+'/'
    file = path+sample+'.segment.loh.cns'
    with open(file, "r") as f:
        seg = f.readlines()
    
    file2 = path+sample+'.pathology.cnv_report.tsv'
    with open(file2, "r") as f:
        report = f.readlines()
        report.pop(0)
        
    # df = pd.read_csv(file2, sep='\t')
    # df2 = df.groupby('callers').get_group('gatk')
    # df = df.groupby('callers').get_group('cnvkit')
    
    # df_all = df.merge(df2, how='outer')
    # df2_outer = df_all.groupby('callers').get_group('gatk')
    # df_outer = df_all.groupby('callers').get_group('cnvkit')
    
    # df_result = np.where(df2_outer['gene(s)'] == df_outer['gene(s)'] and df2_outer['copy_number'] > 6 and df_outer['copy_number'] < 1.4, )
    
    report_list = []
    cnvkit_list = []
    gatk_list = []
    cnvkit_list = []
    copy_normal_list = []
    copy_normal_genes = []

    for line in report:
        lline = line.split('\t')
        report_list.append(lline[1])
        report_genes = lline[1]
    #     if 'gatk' in lline[4]: 
    #         gatk_list.append(lline)
    #     if 'cnvkit' in lline[4]:
    #         cnvkit_list.append(lline)
    
    # report_list_unique = list(set(report_list))
    
    # cnvs_gatk = []
    # cnvs_cnvkit = []
    
    # for gene in report_list_unique:
    #     for line in gatk_list:
    #         if gene in line:
    #             cn_gatk = line[len(line)-1]
    #             cnvs_gatk.append([gene, float(cn_gatk)])
    #     for line in cnvkit_list:
    #         if gene in line:
    #             cn_cnvkit = line[len(line)-1]
    #             cnvs_cnvkit.append([gene, float(cn_cnvkit)])
        
        

    #     if float(lline[5]) < 6 or float(lline[5]) > 1.4:
    #         copy_normal_list.append(lline)
    #         copy_normal_genes.append(lline[1])
        
    # for line in list(set(report_list)):
    #     if line in gatk_list and line in cnvkit_list:
            
        
    small_gene_list = ['BAP1', 'CDKN2B', 'TP53', 'MYCN', 'FGFR4', 'MYC', 'CDK4', 'CDKN2A']
        
    # test = []
    test2 = []
    # lengths = []
    # genes = []
    # reportings = []
    
    # for line in seg:
    #     lline = line.split('\t')
    #     for gene in copy_normal_genes:
    #         if gene in lline[3]:
    #             length = int(lline[2]) - int(lline[1])
    #             lline.append([gene,length])
    #             test.append(lline)
    #             test2.append([gene, length])
    #             genes.append(gene)
    #             lengths.append(length)
    
    # #plt.subplot(1, 2, 1)
    # plt.xticks(rotation=90)
    # plt.scatter(genes, lengths, label=sample)
    # plt.legend(bbox_to_anchor=(1.1, 1.05))
    # plt.savefig('/home/lauri/Documents/chelsea_test/all_genes.png',  bbox_inches='tight')
        

    genes = []
    lengths = []
    testtt = []
    for line in seg:
        lline = line.split('\t')
        testtt.append(re.findall('^[A-Z]*', lline[3]))
        for gene in small_gene_list:
            if gene in lline[3]:
                print(gene)
                length = int(lline[2]) - int(lline[1])
                if gene in report_list:
                    in_report = 'In Report'
                    lline.append([gene,length, in_report])
                    test2.append([gene, length])
                    genes.append(gene)
                    lengths.append(length)
    
    #plt.subplot(1, 2, 2)    
    plt.scatter(genes, lengths, label=sample)
    plt.legend(bbox_to_anchor=(1.1, 1.05))
    plt.savefig('/home/lauri/Documents/chelsea_test/report_list.png',  bbox_inches='tight')
    
    