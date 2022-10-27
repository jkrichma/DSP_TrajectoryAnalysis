
%trajDir = 'G:\My Drive\SCANN Lab\StevenWeisberg\Moore_2020\Materials\DSP_Behavioral_Data\DSP_Trajectories';
%fnOut = 'G:\My Drive\SCANN Lab\StevenWeisberg\Moore_2020\Materials\DSP_Behavioral_Data\DSP_Trajectories\frechet_by_trial.csv';
%templateDir = 'G:\My Drive\SCANN Lab\StevenWeisberg\Moore_2020\Materials\DSP_Behavioral_Data\DSP_Analysis_Code\templates';

function wrapper (trajDir, fnOut, templateDir)

cd(templateDir);

for dspVersion = 1:2
    fnSubjectData = horzcat(templateDir, filesep, 'allTrajectories_', int2str(dspVersion), '.csv');
    fnMapCoords = horzcat(templateDir, filesep, 'dsp_coords_version_',int2str(dspVersion), '.txt');
    fnMapLMs = horzcat(templateDir, filesep, 'lmOnPath_version_',int2str(dspVersion),'.txt');
    createSubjectTrialData (fnSubjectData, fnMapCoords, fnMapLMs, trajDir);
end
[fdTableAll] = createFdTables (trajDir, fnOut, 0, 0);

end