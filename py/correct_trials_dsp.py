# -*- coding: utf-8 -*-
"""
Created on Tue May 10 13:43:52 2022

@author: stevenweisberg
"""
#%%
import os
import pandas as pd
import glob

dir_path = os.path.dirname(os.path.realpath(__file__))


fmri = [
    "dspfmri11002",
    "dspfmri11004",
    "dspfmri11005",
    "dspfmri11006",
    "dspfmri11007",
    "dspfmri11008",
    "dspfmri11009",
    "dspfmri11010",
    "dspfmri11011",
    "dspfmri11012",
    "dspfmri12002",
    "dspfmri12003",
    "dspfmri12005",
    "dspfmri12006",
    "dspfmri12007",
    "dspfmri12009",
    "dspfmri12011",
    "dspfmri12012",
    "dspfmri12013",
    "dspfmri12014",
    "dspfmri21002",
    "dspfmri21003",
    "dspfmri22003",
    "dspfmri22004",
    "dspfmri22005",
    "dspfmri22006",
    "dspfmri22007",
    "dspfmri22009",
    "dspfmri12008",
    "dspfmri21001",
    "dspfmri21002",
]


traj_df = pd.read_csv(
    os.path.join(dir_path, "..", "DSP_Trajectories", "subject_data", "subject_data.txt")
)

traj_df["min"] = traj_df.loc[:, ["Sur", "Rte", "Rev", "Top"]].idxmin(axis=1)

traj_long = traj_df.groupby(["subject", "min"]).count().reset_index()

traj_wide = traj_long.pivot(index="subject", columns="min", values="trial")

traj_wide.fillna(0, inplace=True)

traj_wide["place_resp_index"] = traj_wide["Sur"] / (
    traj_wide["Sur"] + traj_wide["Rte"] + traj_wide["Rev"]
)


traj_avg = traj_df.groupby("subject")[["Sur", "Rte", "Rev"]].mean()
traj_avg = traj_avg.add_suffix("_frechet")

fmri_subjects = []

for i in fmri:
    fmri_subjects.append(int(i[-5:]))

traj_avg_subset = traj_avg[traj_avg.index.isin(fmri_subjects)]
traj_avg_subset.to_csv(
    os.path.join(
        dir_path, "..", "DSP_Trajectories", "subject_data", "frechet_by_subject.csv"
    )
)


traj_wide_subset = traj_wide[traj_wide.index.isin(fmri_subjects)]

traj_wide_subset.to_csv(
    os.path.join(
        dir_path,
        "..",
        "DSP_Trajectories",
        "subject_data",
        "place_resp_index_by_subject.csv",
    )
)

# Correct/incorrect data from old manual coding files
data_dir = os.path.join(dir_path, "..", "DSP_ProcessedData", "To_be_manually_coded")
data_dir_2 = os.path.join(dir_path, "..", "DSP_ProcessedData", "Already_manually_coded")
success_df = pd.DataFrame()

for i in fmri_subjects:
    subj_file = glob.glob(os.path.join(data_dir, f"*{i}_1*"))

    try:
        success_subj_df = pd.read_excel(subj_file[0])
        success_df = pd.concat([success_df, success_subj_df])
    except IndexError or ValueError:
        try:
            subj_file_2 = glob.glob(os.path.join(data_dir_2, f"*{i}_1*"))
            success_subj_df = pd.read_excel(subj_file_2[0])
            success_df = pd.concat([success_df, success_subj_df])
        except IndexError or ValueError:
            pass

success_counts = success_df.groupby(["ParticipantNo", "Status"])[["DSPType"]].count()
success_counts = success_counts.query("Status == 'Success'")
success_counts = success_counts.droplevel("Status")
success_counts = success_counts[success_counts.index.isin(fmri_subjects)]
success_counts.index.names = ["subject"]
success_counts.rename(columns={"DSPType": "success_trials"}, inplace=True)

output_all = pd.merge(traj_wide, success_counts, left_index=True, right_index=True)
output_all = pd.merge(output_all, traj_avg, left_index=True, right_index=True)

output_all.reset_index(inplace=True)
output_all["older_adult"] = output_all["subject"] > 13000


# %%
