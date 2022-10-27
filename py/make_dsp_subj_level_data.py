# -*- coding: utf-8 -*-
"""
Created on Tue Mar 22 12:21:09 2022

@author: stevenweisberg
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import scipy
import scipy.stats
import os

# Find the directory containing this file
base_dir = os.path.dirname(os.path.realpath(__file__))

# Where are the data
data_dir = os.path.join(base_dir,'..','..','Data','DSP_Pilot_Data','boone_data')


df = pd.read_csv(os.path.join(data_dir,'fdTableSc.csv'))

df['min'] = df.loc[:,['Sur','Rte','Rev','Top']].idxmin(axis=1)

long = df.groupby(['subject','min']).count().reset_index()

wide = long.pivot(index='subject',columns='min',values='trial')

wide.fillna(0,inplace=True)

wide['place_resp_index'] = wide['Sur'] / (wide['Sur'] + wide['Rte'] + wide['Rev'])

data = wide['place_resp_index'].values

wide.to_csv(os.path.join(data_dir,'dsp_strategy_distribution.csv'))

df['pri'] = (test['Sur'] - test['Rev'] - test['Rte'])/(test['Rte'] + test['Rev'] + test['Sur'] + test['Top'])
test = df.groupby('subject')[['pri']].mean()

plt.hist(test['pri'])
