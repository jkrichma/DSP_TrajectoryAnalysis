%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
% Copyright(c) 2022 
% Regents of the University of California. All rights reserved.
%  
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
%  
% 1. Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
%  
% 2. Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the distribution.
%  
% 3. The names of its contributors may not be used to endorse or promote
%    products derived from this software without specific prior written
%    permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
% A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
% OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
% TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jeff Krichmar, UC Irvine
%
% runSubjectTrials - Generates path metrics on trials for a given subject.
% @param subNum - subject number
% @param mixed - run the combination of strategies if true. Only 4 "pure" strategies otherwise.
% @param dFD - display the table of Frechet distances between subject and strategies for all trials.
% @param dTrialNum - display paths and distance information for the given trial number.  If set to 999, all trials will be displayed.
function [fdTable,trialNum] = runSubjectTrials(subjectNum, mixed, dFD, dTrialNum, trajDir, dspVersion)

dspVersion = num2str(dspVersion);

mxy = load(horzcat('dsp_coords_version_', dspVersion,'.txt'));
lm = load(horzcat('lmOnPath_version_',dspVersion,'.txt'));
map = getMap(mxy,lm,0);
rte = load(horzcat('learnedRoute_version_',dspVersion,'.txt'));
trials = load(horzcat('trials_version_',dspVersion,'.txt'));

if mixed
    STRATEGIES=14;
else
    STRATEGIES=4;
end

DISPLAY_ALL_TRIALS = 999;

tinx = 0;
trialNum = zeros(1,25);
for t = 1:25
    if isfile([trajDir, filesep, 's', num2str(subjectNum), 't', num2str(t), 'v', dspVersion, '.txt'])
        tinx = tinx + 1;
        trialNum(tinx) = t;
    end
end
fdTable = zeros(tinx,STRATEGIES);

for i=1:tinx
    if dTrialNum == trialNum(i) || dTrialNum == DISPLAY_ALL_TRIALS
        dFlag = true;
    else
        dFlag = false;
    end
    if dFlag
        figure;
    end
    if mixed
        [fdTable(i,1), fdTable(i,2), fdTable(i,3), fdTable(i,4), fdTable(i,5), fdTable(i,6), fdTable(i,7), fdTable(i,8), fdTable(i,9), fdTable(i,10), fdTable(i,11), fdTable(i,12), fdTable(i,13), fdTable(i,14)] = runTrialMixStrat (subjectNum, trialNum(i), trials, map, rte, lm, dFlag, trajDir, dspVersion);
    else
        [fdTable(i,1), fdTable(i,2), fdTable(i,3), fdTable(i,4)] = runTrial (subjectNum, trialNum(i), trials, map, rte, lm, dFlag, trajDir, dspVersion);
    end
end

if dFD
    figure;
    imagesc(fdTable);
    if mixed
        set(gca,'XTick',1:14)
        set(gca,'XTickLabel',{'Sur', 'Top', 'Rte', 'Rev', 'SurRte', 'TopRte', 'SurRev', 'TopRev', 'RteSur', 'RteTop', 'RevSur', 'RevTop', 'SurTop', 'TopSur'})
    else
        set(gca,'XTick',1:4)
        set(gca,'XTickLabel',{'Sur', 'Top', 'Rte', 'Rev'})
    end
    set(gca,'YTick',1:tinx)
    set(gca,'YTickLabel',trialNum)
    title(['Subject ', num2str(subjectNum), ' - Frechet Distance'])
    colorbar;
end

end

