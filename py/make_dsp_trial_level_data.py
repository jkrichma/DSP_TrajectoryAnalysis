# -*- coding: utf-8 -*-
"""
Created on Mon Jun 28 15:16:37 2021



@author: smwei
"""

import os
import glob
import pandas as pd


# Find the directory containing this file
base_dir = os.path.dirname(os.path.realpath(__file__))

# Where are the data
data_dir = os.path.join(base_dir, "..", "..", "DSP_RawData")

# Where should the output go
output_dir = os.path.join(base_dir, "..", "..", "DSP_Trajectories")

# list of input files
input_files = glob.glob(os.path.join(data_dir, "*.txt"))

if not os.path.exists(output_dir):
    print("Making output directory...")
    os.makedirs(output_dir)

df_1 = pd.DataFrame(columns=["SubjectNum", "TrialType", "TrialNum", "Time", "X", "Z"])
df_2 = pd.DataFrame(columns=["SubjectNum", "TrialType", "TrialNum", "Time", "X", "Z"])

# This is originally whether 0 = gtg, 1 = shortcut; but we'll handle this at the subject merge level.
TrialType = 0


for i in range(len(input_files)):
    with open(input_files[i], "r") as f:
        for line in f:
            if "Participant" in line:
                SubjectNum = int(line.split(": ")[-1][:5])
            elif "DSPType" in line:
                dsp_type = int(line.split(": ")[-1])
                f.close()
                break

    print(f"DSP map {dsp_type}. Processing subject {SubjectNum}")

    # Read in the CSV
    data = pd.read_csv(
        input_files[i],
        sep=",",
        header=None,
        skiprows=7,
        names=["a", "b", "c", "d", "e"],
    )

    if "!!" not in data.loc[0, "a"]:
        data = pd.read_csv(
            input_files[i],
            sep=",",
            header=None,
            skiprows=5,
            names=["a", "b", "c", "d", "e"],
        )

    # Process the trial numbers by adding them to the DF
    data["TrialNumRaw"] = ""
    trialIdx = data.index[data["a"].str.contains("!!")].tolist()

    for i, idx in enumerate(trialIdx):
        data.loc[trialIdx[i] :, "TrialNumRaw"] = data.loc[trialIdx[i], "a"]

    # Drop all trial number rows
    data.dropna(axis=0, inplace=True)

    data["TrialNum"] = data["TrialNumRaw"].apply(lambda x: x.split("_")[-1])

    # Process Time, X, Z
    data[["Time", "X"]] = data.a.str.split(expand=True)
    data["Time"] = data["Time"].str.replace(r":$", "", regex=True).astype(float)
    data["Z"] = data["b"].astype(float)
    data["X"] = data["X"].astype(float)

    data["SubjectNum"] = int(SubjectNum)
    data["TrialType"] = TrialType

    if dsp_type == 1:
        df_1 = pd.concat(
            [df_1, data[["SubjectNum", "TrialType", "TrialNum", "Time", "X", "Z"]]]
        )
    elif dsp_type == 2:
        df_2 = pd.concat(
            [df_2, data[["SubjectNum", "TrialType", "TrialNum", "Time", "X", "Z"]]]
        )

df_1.to_csv(os.path.join(output_dir, "allTrajectories_1.csv"), index=False)
df_2.to_csv(os.path.join(output_dir, "allTrajectories_2.csv"), index=False)
