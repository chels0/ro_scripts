#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 31 15:26:52 2023

@author: lauri
"""

import pandas as pd

panel_560 = pd.read_csv('/home/lauri/Desktop/gen_lista_560.tsv')
panel_560.columns = ['gene']
breast = pd.read_csv('/home/lauri/Documents/chelsea_test/breast_carcinoma.csv')
breast.columns = ['gene']

test = pd.merge(panel_560, breast, how = "inner")

test.to_csv('/home/lauri/Documents/chelsea_test/breast_carcinoma_genes_overlap_560.csv', header=False, index=False, encoding = 'UTF-8')
