# -*- coding: utf-8 -*-
"""
Created on Fri Apr 22 15:07:34 2022

@author: stevenweisberg
"""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Load in dataframe from UCSB Data
df = pd.read_csv('G:\\My Drive\\SCANN Lab\\StevenWeisberg\\Moore_2020\\Materials\\DSP_Behavioral_Data\\DSP_Trajectories\\subject_data\\subject_data.txt',index_col=['subject','trial'])
# Remove topological strategy
df.drop(['Top'],axis=1,inplace=True)

# Goofy subject names; replacing these for now.
df.rename(index={120022: 12002, 210012: 21001, 210022: 21002},level='subject',inplace=True)

df['oa'] = df.index.get_level_values('subject') > 12999

# Determine whether there are ties or not
df_sub = df[['Rte','Rev','Sur']]
idx = df_sub.eq(df_sub.min(axis=1), axis=0)
df['strategy'] = np.where(df_sub.eq(df_sub.min(1),0).sum(1)>1,'tie',df_sub.idxmin(1))

distance = df.groupby(['subject']).agg({'Rte': 'mean','Sur': 'mean','Rev':'mean','oa': 'first','strategy':'count'})

distance_long = pd.melt(distance.reset_index(),id_vars=['subject','oa'],value_vars=['Sur','Rte','Rev'],var_name='strategy',value_name='distance')

ax = sns.boxplot(x='strategy',y='distance',hue='oa',data=distance_long)
ax = sns.swarmplot(x='strategy',y='distance',hue='oa',data=distance_long)



# Pivot and get trial counts
counts_long = df.groupby(['subject','strategy']).agg({'Sur': 'count','oa':'first'}).reset_index()

counts_long.rename(columns={"Sur": "trial_counts"},inplace=True)

wide = counts_long.pivot(index='subject',columns='strategy',values='trial_counts')
wide.fillna(0,inplace=True)

# Assemble route index
wide['route_all'] = wide['Rev'] + wide['Rte']# + wide['Rte,Rev']

# Plot route and surveys
fig = sns.histplot(wide[['Sur','route_all']],stat='probability',bins=10)
plt.xlabel('Trials')
fig.spines['top'].set_visible(False)
fig.spines['right'].set_visible(False)
plt.legend(['Route','Survey'],frameon=False)
fig.xaxis.set_major_formatter(plt.FormatStrFormatter('%d'))
plt.show(fig)


ax1 = sns.boxplot(x='strategy',y='trial_counts',hue='oa',data=counts_long)
ax1 = sns.swarmplot(x='strategy',y='trial_counts',hue='oa',data=counts_long)
