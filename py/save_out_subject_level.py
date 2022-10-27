# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import os
import pandas as pd

dir_path = os.path.dirname(os.path.realpath(__file__))

df = pd.read_csv(os.path.join(dir_path,'..','DSP_Trajectories','subject_data','subject_data.txt'))


df['min'] = df.loc[:,['Sur','Rte','Rev','Top']].idxmin(axis=1)

long = df.groupby(['subject','min']).count().reset_index()

wide = long.pivot(index='subject',columns='min',values='trial')

wide.fillna(0,inplace=True)

wide['place_resp_index'] = wide['Sur'] / (wide['Sur'] + wide['Rte'] + wide['Rev'])


#wide.to_csv(os.path.join(data_dir,'dsp_strategy_distribution.csv'))

output = df.groupby('subject')[['Sur','Rte','Rev']].mean()


fmri = ['dspfmri11002','dspfmri11004','dspfmri11005','dspfmri11006',
        'dspfmri11007','dspfmri11008','dspfmri11009','dspfmri11010',
        'dspfmri11011','dspfmri11012','dspfmri12002','dspfmri12003',
        'dspfmri12005','dspfmri12006','dspfmri12007','dspfmri12009',
        'dspfmri12011','dspfmri12012','dspfmri12013','dspfmri12014',
        'dspfmri21002','dspfmri21003','dspfmri22003','dspfmri22004',
        'dspfmri22005','dspfmri22006','dspfmri22007','dspfmri22009',
        'dspfmri12008']

fmri_subjects = []

for i in fmri:
    fmri_subjects.append(int(i[-5:]))
    
df_subset = output[output.index.isin(fmri_subjects)]
df_subset.to_csv(os.path.join(dir_path,'..','DSP_Trajectories','subject_data','frechet_by_subject.csv'))


wide_subset = wide[wide.index.isin(fmri_subjects)]

wide_subset.to_csv(os.path.join(dir_path,'..','DSP_Trajectories','subject_data','place_resp_index_by_subject.csv'))





