
%trajDir = 'G:\My Drive\SCANN Lab\StevenWeisberg\Moore_2020\Materials\DSP_Behavioral_Data\DSP_Trajectories';
%fnOut = 'G:\My Drive\SCANN Lab\StevenWeisberg\Moore_2020\Materials\DSP_Behavioral_Data\DSP_Trajectories\frechet_by_trial.csv';

function wrapper (trajDir, fnOut)



for dspVersion = 1:2
    fnSubjectData = horzcat('allTrajectories_', int2str(dspVersion), '.csv');
    fnMapCoords = horzcat('dsp_coords_version_',int2str(dspVersion), '.txt');
    fnMapLMs = horzcat('lmOnPath_version_',int2str(dspVersion),'.txt');
    createSubjectTrialData (fnSubjectData, fnMapCoords, fnMapLMs, trajDir);
end
[fdTableAll] = createFdTables (trajDir, fnOut, 0, 0)

end